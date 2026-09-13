# Turnstile / Email-Abuse Mitigation — Rollout Plan & Status

**Last updated:** 2026-09-10
**Owner:** Alouise
**Related:** [AUDIT_FINDINGS.md](AUDIT_FINDINGS.md) · memory `project_email_abuse_captcha.md`

> ## ✅ COMPLETE (verified 2026-09-10): Turnstile ENFORCING in prod, alongside double opt-in.
> - **API** (PR #45, merged 08-26): `TURNSTILE_SECRET_KEY` set on App Runner → enforcing. Verified: `forgot-password` with no token → **403**.
> - **Web** (PR #47, merged 08-26): prod bundle ships the real site key (`0x4AAAAAAECKfHs43HQOz6iC`).
> - **Double opt-in** (api #44 / web #45, merged 08-21/22) stays on as email-ownership proof + backstop.
> - **Marketing changelog** PR #5 merged 08-22.
>
> **Still open:** ship a native build so installs pick up the OAuth-only auth UX (see [Native](#native-oauth-only)); monitor Gmail reputation via **Google Postmaster Tools** (if dented, move the verification-email sender to a subdomain); optional staging cleanup.

---

## Why this exists (the incident)

Resend logs showed **email/subscription-bombing abuse**: attackers registered accounts with *victims'* email addresses so TenXRep would send them unsolicited welcome + password-reset emails (register→reset pairs, incl. an email-to-SMS gateway and real corporate domains). The app was being used as a **spam relay**, not hacked. Real damage = **sender-domain reputation** (Resend showing Suppressed/Bounced).

The two abused endpoints (unauthenticated, send email to any address):
- `POST /auth/register/username` (open-registration path) → welcome email (now: verification email)
- `POST /auth/forgot-password` → reset email

---

## Final design: CAPTCHA + double opt-in (defense in depth)

- **Turnstile** stops the automation (bot volume). Gated: open registration + forgot-password. **Not** gated: invite-flow registration (admin-token-gated), Google/Apple auth, login.
- **Double opt-in** removes most of the abuse primitive — open registration only sends a verification link, never a welcome email to an unverified address — plus a per-email throttle. On its own it capped the harm but didn't stop scripted registration (one victim email per attempt), which is why Turnstile came back.

### Native: OAuth-only

Turnstile has no native SDK, and an `Origin`-header exemption is client-spoofable (a script can send `Origin: capacitor://localhost`), so there's **no native bypass**. Instead (web PR #47):
- Open username signup form is hidden on native, replaced by a "sign up on web" link. Invite-flow signup still works.
- Native forgot-password sends the user to the web flow.
- Google/Apple sign-in and login are unaffected.

**Caveat — needs a native build:** the last iOS release (06-23) predates #47. Existing installs still show the username form → submit → 403 error toast. Ship a native build to close this. If native username signup ever proves necessary/abused, the non-spoofable gate is iOS **App Attest** / Android **Play Integrity**, or a CAPTCHA vendor with a native SDK (hCaptcha / reCAPTCHA Enterprise).

---

## Current state (2026-09-10)

| Surface | State |
|---|---|
| **Prod web** (app.tenxrep.com) | Widget live, real site key in build |
| **Prod API** | **Enforcing** (secret set) — verified 403 |
| **Staging web** (staging.tenxrep.com) | Stale build (no widget). Left as-is on purpose |
| **Staging API** | Secret may be set → would enforce, but staging web sends no token (known, low-priority) |
| **Native iOS/Android** | Shipped builds predate OAuth-only UX → username signup/reset 403s. Fixed by next native build |
| **Local dev** | Fail-open. `api/.env` has NO secret; web `.env.local` has the dummy test site key. No real secret in any local file |

---

## Tasks

- [x] Scrap the native-exemption branch (local-only, never pushed) — 2026-08-17.
- [x] Double opt-in email verification (api #44, web #45) — merged 08-21/22.
- [x] Re-add Turnstile alongside double opt-in (api #45, web #47) — merged 08-26.
- [x] Set `VITE_TURNSTILE_SITE_KEY` (Vercel) → rebuilt; key in prod bundle.
- [x] Set `TURNSTILE_SECRET_KEY` (App Runner) → enforcing.
- [x] Verify enforcement — 403 on 2026-09-10. Canonical check (no account created, no email sent):
  ```bash
  curl -s -o /dev/null -w "%{http_code}\n" -X POST \
    https://mqq3xyhgt5.us-west-2.awsapprunner.com/api/v1/auth/forgot-password \
    -H 'Content-Type: application/json' -d '{"email":"probe@example.com"}'
  # 403 = enforcing; 200 = fail-open (secret missing)
  ```
- [x] Merge marketing changelog PR #5 — 08-22.
- [ ] **Ship a native build** with the OAuth-only auth UX (see caveat above).
- [ ] Monitor Gmail reputation (Google Postmaster Tools).
- [ ] *(optional)* Redeploy staging web from main + reconcile the staging secret.
- [ ] From the audit: dependency bumps (`python-multipart`/`starlette`, `npm audit fix` web+marketing), `beta_signups` PII gap on account deletion. See [AUDIT_FINDINGS.md](AUDIT_FINDINGS.md).

---

## PRs

| Repo | PR | What | State |
|---|---|---|---|
| tenxrep-api | #39 (+#40) | Legacy `/users/register` removed, rate-limit IP-keying fix, `datetime.UTC` crash fix | Merged |
| tenxrep-api | #41 | Turnstile + deactivation, **stacked on #39 branch** | Merged into #39 branch — **never reached main** (footgun) |
| tenxrep-api | #42 | Same code re-targeted to main | Merged |
| tenxrep-web | #44 | Turnstile widget, CSP, admin deactivate button | Merged |
| tenxrep-api | #44 | Double opt-in + per-email throttle (+ removed Turnstile) | Merged 08-21 |
| tenxrep-web | #45 | Double opt-in UI (+ removed widget) | Merged 08-22 |
| tenxrep-marketing | #5 | Changelog: email verification + custom-exercise fix | Merged 08-22 |
| tenxrep-api | #45 | Re-add Turnstile (keep double opt-in) + stub Resend in tests | Merged 08-26 |
| tenxrep-web | #47 | Re-add widget (keep double opt-in) + native OAuth-only steering | Merged 08-26 |

**Lesson (recorded):** don't stack a PR on a non-`main` base and expect it to reach `main` — merging a stacked PR merges into its base branch, not main. Land backend work directly on main or re-target.

**Timeline, for the record:** Turnstile shipped fail-open (07-30) → held off over native → retired in favor of double opt-in (08-20) → abuse resumed through verification emails → Turnstile re-added alongside double opt-in (08-26) → enforcing.

---

## Env var reference

| Var | Where | Value | Notes |
|---|---|---|---|
| `VITE_TURNSTILE_SITE_KEY` | Vercel (prod), web `.env.production.local` | real **site** key (public) | Build-time (Vite) — rebuild after changes |
| `VITE_TURNSTILE_SITE_KEY` | web `.env.local` (dev) | `1x00000000000000000000AA` (test) | Cloudflare always-pass test key |
| `TURNSTILE_SECRET_KEY` | prod App Runner | real secret — **SET** | Runtime; unsetting it = fail-open |
| `TURNSTILE_SECRET_KEY` | api `.env` (dev) | unset | Fail-open locally; use test secret `1x0000000000000000000000000000000AA` to exercise enforcement |

Cloudflare test keys: site `1x00000000000000000000AA`, secret `1x0000000000000000000000000000000AA` (both always pass). Real site key is public (ships in the JS bundle); real **secret** must never sit in a local file.

---

## How enforcement is designed (so behavior is predictable)

- Backend `app/services/turnstile.py`: **fail-open** when `TURNSTILE_SECRET_KEY` unset (dev/test), **fail-closed** when set (missing/invalid token → 403, siteverify outage → 503).
- `is_active` enforced in `get_current_user` (all authed routes), password login, and forgot-password — so admin deactivate (`PATCH /admin/users/{id}/active`) actually locks bots out and invalidates their JWTs.
