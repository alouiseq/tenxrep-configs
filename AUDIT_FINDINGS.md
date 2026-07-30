# TenXRep Audit Findings

**Last audit:** 2026-07-29 (security-focused: triggered by suspicious signup burst — registration surface, injection, rate limiting/DoS)
**Previous audit:** 2026-06-05
**Scope:** `tenxrep-api` + `tenxrep-web` (marketing npm audit only)
**Method:** Read-only inline investigation.

For the audit checklist used to scope each pass, see [SECURITY_AUDIT.md](SECURITY_AUDIT.md). This file tracks findings + status across audits.

When re-auditing, **verify each open finding is still present** before acting — code may have changed since this was written.

---

## Status legend

- `[ ]` Open — needs fixing
- `[x]` Fixed — verify before removing from list
- `[~]` Won't fix / accepted risk
- `[?]` Needs re-verification

---

## HIGH severity

- [x] **Legacy `POST /users/register` — unauthenticated, no rate limit, zero validation.** *(new 2026-07-29; fixed in tenxrep-api PR #39 — verify on staging, then prod after merge)*
  `tenxrep-api/app/api/v1/endpoints/users.py:22-51`. Predates the `/auth/register/*` flow and was never removed. `UserCreate` schema (`app/schemas/user.py:10`) has no password min-length, no username length/charset rules — any string passes. No `@limiter.limit`, no Slack notification, no welcome email, no `trial_ends_at` set. Nothing in `tenxrep-web` or marketing references it — it is dead code that only an attacker (or a bot scanning `/docs`) would find. Likely entry point for junk/bot accounts.
  **Fix:** Delete the endpoint (and `UserCreate` if unused elsewhere). Update `oauth2_scheme` tokenUrl if needed (`core/auth.py:14` points at `users/login`, not register — unaffected).

- [x] **Rate limiting is ineffective in production — all clients share one bucket.** *(new 2026-07-29; fixed in tenxrep-api PR #39 via rightmost-XFF key_func — verify on staging with the 6-rapid-logins check in the PR)*
  `startup.py` runs uvicorn without `--proxy-headers`; slowapi's `get_remote_address` reads `request.client.host`, which behind App Runner is the request router's IP, not the caller's. Every client therefore shares the same per-IP bucket. Consequences: (a) an attacker sending >5 login req/min locks **all** users out of `/users/login` (auth DoS); (b) per-attacker brute-force throttling is meaningless. The 2026-06-05 "rate limiting wired" verified-solid item was wrong in effect, though the decorators are present.
  **Fix:** Give slowapi a custom `key_func` that takes the **rightmost** entry of `X-Forwarded-For` (the one appended by App Runner — leftmost entries are client-spoofable). Do NOT use `--forwarded-allow-ips='*'` + leftmost XFF: that lets attackers rotate spoofed IPs to bypass limits entirely.
  Canonical topic: trusting proxy headers / IP spoofing behind load balancers.

- [~] **Email/subscription-bombing abuse via transactional emails.** *(new 2026-07-30 — confirmed active via Resend logs: register→reset email pairs to victims' addresses incl. an email-to-SMS gateway and real corporate domains; Resend already showing Suppressed/Bounced)*
  Root threat behind the "suspicious signups": TenXRep was being used as a spam relay, not hacked. Both unauthenticated email endpoints send mail to attacker-supplied addresses with no proof of ownership.
  **Mitigation shipped (stopgap):** Cloudflare Turnstile CAPTCHA on `POST /auth/register/username` (open path) + `POST /auth/forgot-password` — tenxrep-api PR #41 (backend, fail-open until `TURNSTILE_SECRET_KEY` set) + tenxrep-web PR #44 (widget + CSP). Set `TURNSTILE_SECRET_KEY` / `VITE_TURNSTILE_SITE_KEY` in prod+staging to activate.
  **Still open:** full double opt-in email verification (durable fix — deferred; see below).

- [x] **`is_active` was barely enforced — deactivation was cosmetic.** *(found & fixed 2026-07-30, tenxrep-api PR #41)*
  Only Google/Apple login checked `is_active`; password login, `get_current_user` (i.e. every authed route), and forgot-password ignored it. Now enforced in all three, plus a new reversible admin endpoint `PATCH /admin/users/{id}/active` and a deactivate/reactivate button in the web admin (PR #44). This is the tool to flag the 4 bot accounts.

- [ ] **No email verification on registration (double opt-in).** *(new 2026-07-29; partially mitigated 2026-07-30 by CAPTCHA above — full fix still deferred)*
  All register endpoints (`/auth/register/username`, legacy `/users/register`) accept any email unverified; a welcome email is sent immediately. Bots can register with strangers' real addresses → spam complaints against your Resend domain reputation, and the real owner can later be blocked from registering ("account already exists"). Also means the 4 suspicious signups' emails prove nothing about who owns them.
  **Fix:** Send a verification link; gate welcome email (or account activation) on it. Interim mitigation: none cheap — prioritize after rate-limit fix.

- [ ] **Vulnerable dependencies with DoS/RCE-class advisories.** *(new 2026-07-29)*
  - `tenxrep-api`: `python-multipart 0.0.21` — 6 advisories incl. multipart DoS (parses the **unauthenticated** `/users/login` form body); `starlette 0.50.0` — 5 advisories incl. multipart DoS; `pyjwt 2.10.1` (transitive), `python-dotenv 1.0.0`, `ecdsa 0.19.2` (Minerva, no fix — python-jose dep).
  - `tenxrep-web`: 27 vulns (1 critical: `protobufjs` ≤7.6.4 via `posthog-js → @opentelemetry` chain; high: `lodash`, `glob`, `brace-expansion`, `@remix-run/router`). `npm audit fix` covers most.
  - `tenxrep-marketing`: 16 vulns (1 critical, 4 high).
  **Fix:** Bump `python-multipart` ≥0.0.31 and `starlette` (with FastAPI compat check), `npm audit fix` in both frontends, re-run audits.

- [x] **`POST /muscle-groups` has no auth dependency.**
  *(fixed 2026-07-29 in tenxrep-api PR #39 — now `Depends(get_current_admin)`, with 401/403/200 regression tests)* `tenxrep-api/app/api/v1/endpoints/muscle_groups.py:33-39` — anyone can POST and insert rows. Every other admin-shaped endpoint uses `Depends(get_current_admin)`; this one is the lone hole.
  **Fix:** Add `current_user: User = Depends(get_current_admin)` to the signature.

- [x] **`datetime.UTC` used in production code — will crash on Python 3.11.**
  *(fixed 2026-07-30 in tenxrep-api PR #39 — regression test reproduces the AttributeError without the fix; trial gate + free-cap paths both covered)* `tenxrep-api/app/api/v1/endpoints/exercises.py:113` reads `datetime.now(datetime.UTC)`. Project pins 3.11; `datetime.UTC` is 3.12-only. Violates pitfall #9 in `tenxrep-api/CLAUDE.md`.
  **Fix:** Replace with `datetime.now(timezone.utc)` and import `timezone`. Add `# noqa: UP017` if ruff complains.

- [ ] **Account deletion leaves PII in `beta_signups`.**
  *(re-verified still open 2026-07-29)* `_delete_user_data` in `tenxrep-api/app/api/v1/endpoints/users.py:87` scrubs 9 child tables but skips `beta_signups` (keyed by email, unique-indexed). Privacy/GDPR exposure for users who signed up to the beta and later delete.
  **Fix:** Add `db.query(BetaSignup).filter(BetaSignup.email == user.email).delete()` before the final `db.delete(user)`.

---

## MEDIUM severity

- [ ] **Registration/login error messages enable account enumeration.** *(new 2026-07-29)*
  `auth.py` register endpoints return "An account already exists for {email}" / "Username '{x}' is already taken". `/forgot-password` correctly returns a generic message, but the register path leaks the same signal. Acceptable UX tradeoff for many apps — decide deliberately. Given bot probing, consider a generic "registration failed" + email-me-instead flow later.

- [ ] **No rate limits on authenticated write endpoints.** *(new 2026-07-29)*
  Only auth endpoints are decorated. A hostile trial account can create unbounded workouts/sets/PRs (custom exercises are capped at 5 for free). DB-flooding vector once the attacker has any account. Fix cheaply with a default app-wide limit (`slowapi` default_limits, e.g. 120/min) once the key_func fix lands — pointless before it.

- [ ] **No request body size limit.** *(new 2026-07-29)*
  Neither uvicorn nor FastAPI caps request body size by default; large JSON bodies consume parse CPU/memory before Pydantic rejects shape. Add a small ASGI middleware rejecting bodies > ~1 MB (Content-Length check + streaming cap).

- [ ] **slowapi uses in-memory storage.** *(new 2026-07-29)*
  Limits are per-instance and reset on every deploy; if App Runner scales to N instances, effective limits multiply by N. Fine at current scale — move to Redis-backed storage (`storage_uri`) if instance count grows. Canonical topic: distributed rate limiting.

- [ ] **Web coverage tooling is broken.**
  `tenxrep-web/package.json` defines `"test:coverage": "vitest --coverage"` but `@vitest/coverage-v8` is not a dependency. Coverage script errors immediately. No web coverage has been measured.
  **Fix:** `npm i -D @vitest/coverage-v8` in `tenxrep-web`.

- [ ] **Critical untested business-logic paths.** API service coverage (from `pytest --cov`):
  | File | % covered |
  |---|---|
  | `app/services/recommendation_engine.py` | 15% |
  | `app/services/apple_iap.py` | 27% |
  | `app/services/apple_oauth.py` | 29% |
  | `app/services/google_oauth.py` | 41% |
  | `app/services/email_service.py` | 54% |

  No test files exist for these endpoints:
  - `subscriptions.py` — **Stripe webhook entirely untested.** Tier-transition handlers (`checkout.session.completed`, `customer.subscription.deleted`, `customer.subscription.updated`) have zero regression coverage. Apple side has `test_apple_iap.py`; Stripe has nothing parallel.
  - `auth.py` — Google/Apple OAuth register/login/link flows. Password reset is covered.
  - `admin.py` — including `update_user_subscription` and `admin_delete_user`.
  - `recommendations.py`

- [ ] **Oversized components — splits overdue.**
  - `pages/Index.tsx` — 2052 lines
  - `components/SettingsView.tsx` — 1822
  - `components/ExerciseCard.tsx` — 1351
  - `pages/Admin.tsx` — 1143
  - `pages/ExerciseLibrary.tsx` — 1091

  `SettingsView.tsx` is the cleanest first target — already has `SettingsView.test.tsx`, so splitting into per-section subcomponents won't break tests.

- [ ] **19 one-off DB-write scripts in `tenxrep-api/scripts/`.**
  Per pitfall #8 in `tenxrep-api/CLAUDE.md`, these should be migrations. Risk now is mostly future devs running them in error. Examples: `fix_glute_exercises.py`, `cleanup_incorrect_exercises.py`, `reassign_glute_muscles.py`, `update_glute_exercises.py`, `fix_squat_exercises.py`.
  **Fix:** Delete scripts already applied to prod. Keep only legitimately script-shaped tasks (`seed_data.py`, `seed_skills.py`, `create_demo_data.py`, `create_test_user.py`, `extract_all_exercises.py`).

---

## LOW severity

- [ ] **14 `console.log/warn/error` calls in `tenxrep-web/src` production code.** Sweep to remove or route through Sentry.

- [ ] **10 broad `except Exception:` clauses in `tenxrep-api/app`.** Most are intentional (Slack/email failures shouldn't block requests) and all log. Low concern, included for awareness.

- [x] **Pre-existing flaky tests.** *(root-caused & fixed 2026-07-29, PR #39)* `test_beta_signup.py` / `test_forgot_reset_password.py` flakiness was NOT fixture leakage — the rate limiter was silently live during some test runs. `pytest.ini`'s `env` option needs the pytest-env plugin (not installed), so `TESTING=true` was never applied, and the limiter's fallback detection (`"pytest" in $_`) depends on whether tests run via `pytest` vs `python -m pytest`. Rate-limited endpoints then returned 429 mid-suite. conftest.py now sets `TESTING=true` before app import.

- [ ] **`feedback.py:48` doesn't wrap `send_feedback_notification` in try/except** while every other Slack call site does. If Slack is down, feedback submission fails. Inconsistent.

---

## Verified solid (re-verify next audit)

These items were checked and were correct as of 2026-06-05 — no need to re-investigate from scratch next time, but verify quickly:

- Stripe webhook signature validation (`subscriptions.py:133-140` uses `stripe.Webhook.construct_event`, raises 400 on `SignatureVerificationError`)
- Apple JWS validation (`app/services/apple_iap.py` — x5c chain + ES256 + DER signatures + bundle ID check + Apple Root CA G3 pinned, per pitfall #10)
- ~~Rate limiting wired~~ **RETRACTED 2026-07-29** — decorators exist but keying is broken behind App Runner; see HIGH finding above
- CORS explicit allow-list, no wildcards (`main.py:42-54`) — re-verified 2026-07-29
- Cron endpoint `/internal/trial-reminders/run` gated by `X-Cron-Secret` with `secrets.compare_digest`, 503 when unset (`cron.py:20-31`) — verified 2026-07-29
- No `SECRET_KEY`/`DATABASE_URL` insecure defaults — both required fields in `config.py`, app fails to boot without them — verified 2026-07-29
- Only `dangerouslySetInnerHTML` in web is shadcn `chart.tsx` self-generated CSS (no user input) — verified 2026-07-29
- Auth-dependency sweep across all endpoint files: every write route has `get_current_user`/`get_current_admin`/`check_not_readonly` except the two signature-verified webhooks, `POST /muscle-groups` (open HIGH), and legacy `POST /users/register` (new HIGH) — verified 2026-07-29
- Username validation on the real register path (`/auth/register/username`): 3-20 chars, `^[a-zA-Z0-9_-]+$`, password ≥8 — verified 2026-07-29
- Password reset flow: typed JWT (`type=password_reset`), 1h expiry, generic responses, no enumeration — verified 2026-07-29
- No hardcoded secrets in tracked source (grep clean for `sk_live`, `whsec_`, `hooks.slack.com`, etc.)
- All `VITE_*` env vars are public-safe (API URL, public Google client ID, public Stripe price ID, PostHog public key, Sentry DSN)
- TypeScript `any` count: 0 in production code
- Alembic head count: 1 (no migration conflicts)
- `.env` files not tracked in git (only `.env.example`)

---

## Coverage baseline (2026-06-05)

- **API:** 64% total line coverage, 265 tests passing (171s wall time)
- **Web:** Could not measure — coverage tooling broken (see MEDIUM #4)

---

## How to re-audit

1. Re-run the coverage commands to refresh numbers:
   ```bash
   cd tenxrep-api && source venv/bin/activate && pytest --cov=app --cov-report=term
   cd tenxrep-web && npm run test:coverage   # once @vitest/coverage-v8 is installed
   ```
2. For each open `[ ]` item above, grep/read to confirm it's still present.
3. New audit pass: focus areas in `SECURITY_AUDIT.md` checklist.
4. Update this file in place — mark items `[x]` as fixed, add new findings.
