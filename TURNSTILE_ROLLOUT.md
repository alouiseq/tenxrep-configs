# Turnstile / Email-Abuse Mitigation — Rollout Plan & Status

**Last updated:** 2026-07-30
**Owner:** Louie
**Related:** [AUDIT_FINDINGS.md](AUDIT_FINDINGS.md) · memory `project_email_abuse_captcha.md`

Handoff doc for the in-progress Cloudflare Turnstile rollout. Read this first if picking the work back up.

---

## Why this exists (the incident)

Resend logs showed **email/subscription-bombing abuse**: attackers registered accounts with *victims'* email addresses so TenXRep would send them unsolicited welcome + password-reset emails (register→reset pairs, incl. an email-to-SMS gateway and real corporate domains). The app was being used as a **spam relay**, not hacked. Real damage = **sender-domain reputation** (Resend showing Suppressed/Bounced). Fix = CAPTCHA now (stop automated triggering) + double opt-in later (remove the primitive).

The two abused endpoints (unauthenticated, send email to any address):
- `POST /auth/register/username` (open-registration path) → welcome email
- `POST /auth/forgot-password` → reset email

---

## Current state (2026-07-30)

| Surface | State |
|---|---|
| **Prod web** (app.tenxrep.com) | Turnstile widget **visible + working** (real site key in build) |
| **Prod API** | Turnstile code deployed (api PR #42); **enforcement OFF** — `TURNSTILE_SECRET_KEY` intentionally removed |
| **Staging web** (staging.tenxrep.com) | **Stale** pre-#44 build (no widget). Left as-is on purpose |
| **Staging API** | Has Turnstile code; secret may still be set → would enforce, but staging web sends no token (known, low-priority) |
| **Native iOS/Android** | Shipped builds have **no** site key → no widget. `.env.production.local` now has it for the *next* build |
| **Local dev** | Test keys both sides (dummy, always-pass). No real secret in any local file. Real (public) site key only in `.env.production.local` |

**Net:** prod is **fail-open** — widget shows, nothing enforced, nothing can break. Safe holding state.

---

## ⚠️ The blocker: don't enable enforcement until native is resolved

Setting `TURNSTILE_SECRET_KEY` on prod App Runner turns enforcement ON. **Do NOT do this yet.** The shipped native apps have no widget, so enforcement would **403 native username signup + username password-reset on every existing install** (can't be patched — App Store update required). Google/Apple sign-in and login are unaffected (not gated).

---

## The deciding test: does Turnstile work in the Capacitor webview?

iOS origin is `capacitor://localhost` (hostname `localhost`, which *is* in the widget allowlist); the open question is whether the `capacitor://` custom scheme breaks Turnstile.

**Run it:**
```bash
cd tenxrep-web && git checkout main && git pull && nvm use
npm run build            # production mode → .env.production.local → real site key
npx cap sync ios
npx cap open ios         # Xcode → run simulator/device → Register screen
```
Check the widget only (don't submit — iOS build hits prod API and would create a real account).

**Outcome → path:**
- **Widget renders + hits "Success"** → Turnstile works in webview. Ship a native build with it, then re-enable enforcement. *No backend bypass.* (Cleaner end-state.)
- **Blank / error (110200, 300xxx)** → native can't use Turnstile. Build the **backend native exemption** (see below), then re-enable.

---

## Pending tasks (ordered)

- [ ] **Run the iOS webview test** (above) — decides the native path.
- [ ] **Handle native** per the result:
  - Works → confirm site key ships in native builds (already in `.env.production.local`), release an app update.
  - Fails → implement backend native exemption. **Prefer Origin-based** (`Origin: capacitor://localhost` / `http://localhost`) over a new header: it covers *existing* installs with no rebuild. Note it's **spoofable** (values are public) → the native path then leans on per-IP rate limiting as the backstop; web stays gated. Document the tradeoff in the PR.
- [ ] **Re-set `TURNSTILE_SECRET_KEY` on prod App Runner** — ONLY after native is handled. Setting it triggers a config redeploy; enforcement goes live.
- [ ] **Verify enforcement:** `curl` register with no token → expect **403** (was 201 while fail-open). Delete any test account created.
- [ ] **Merge marketing changelog PR #5** — custom-exercise fix is safe to publish now; the bot-protection line can wait until enforcement is fully live if you prefer.
- [ ] *(optional)* Redeploy staging web from main + reconcile the staging secret so staging is consistent.

## Deferred (durable fixes, not started)

- [ ] **Double opt-in email verification** — the real fix: don't create the account / send welcome until an emailed link is clicked. Removes the abuse primitive entirely; CAPTCHA only raises cost.
- [ ] From the audit: dependency bumps (`python-multipart`/`starlette`, `npm audit fix` web+marketing), `beta_signups` PII gap on account deletion. See [AUDIT_FINDINGS.md](AUDIT_FINDINGS.md).

---

## PRs

| Repo | PR | What | State |
|---|---|---|---|
| tenxrep-api | #39 (+#40) | Legacy `/users/register` removed, rate-limit IP-keying fix, `datetime.UTC` crash fix | Merged to main |
| tenxrep-api | #41 | Turnstile + deactivation, **stacked on #39 branch** | Merged into #39 branch — **never reached main** (footgun) |
| tenxrep-api | #42 | Same code **re-targeted to main** | **Merged + deployed** ✅ |
| tenxrep-web | #44 | Turnstile widget, CSP, admin deactivate button | Merged to main ✅ |
| tenxrep-marketing | #5 | Changelog entry | **Open** — review/merge when timing's right |

**Lesson (recorded):** don't stack a PR on a non-`main` base and expect it to reach `main` — merging a stacked PR merges into its base branch, not main. Land backend work directly on main or re-target.

---

## Env var reference

| Var | Where | Value | Notes |
|---|---|---|---|
| `VITE_TURNSTILE_SITE_KEY` | Vercel (prod), web `.env.production.local` | real **site** key (public) | Build-time (Vite) — rebuild after changes |
| `VITE_TURNSTILE_SITE_KEY` | web `.env.local` (dev) | `1x00000000000000000000AA` (test) | Cloudflare always-pass test key |
| `TURNSTILE_SECRET_KEY` | prod App Runner | **REMOVED** (re-add to enable) | Runtime; setting it = enforcement ON |
| `TURNSTILE_SECRET_KEY` | api `.env` (dev) | `1x0000000000000000000000000000000AA` (test) | Always-verifies test secret |

Cloudflare test keys: site `1x00000000000000000000AA`, secret `1x0000000000000000000000000000000AA` (both always pass). Real site key is public (ships in the JS bundle); real **secret** must never sit in a local file.

---

## How enforcement is designed (so behavior is predictable)

- Backend `app/services/turnstile.py`: **fail-open** when `TURNSTILE_SECRET_KEY` unset (dev/test/native), **fail-closed** when set (missing/invalid token → 403, siteverify outage → 503).
- Gated: open registration + forgot-password. **Not** gated: invite-flow registration (admin-token-gated), Google/Apple auth, login.
- `is_active` now enforced in `get_current_user` (all authed routes), password login, and forgot-password — so admin deactivate (`PATCH /admin/users/{id}/active`) actually locks bots out and invalidates their JWTs.
