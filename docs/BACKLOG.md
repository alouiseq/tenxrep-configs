# TenXRep Backlog

Single list of planned work across all four projects. Add items here rather than leaving them in session notes.

**Specialized trackers this doc links to, not duplicates:**

| Tracker | Scope |
|---|---|
| [AUDIT_FINDINGS.md](../AUDIT_FINDINGS.md) | Security/quality audit (16 open, 8 fixed) |
| [TURNSTILE_ROLLOUT.md](../TURNSTILE_ROLLOUT.md) | Email-abuse mitigation — done, 3 open items pulled in below |
| [user-interview-plan.md](user-interview-plan.md) | Interview campaign + decision gate |
| [MONETIZATION_STRATEGY.md](MONETIZATION_STRATEGY.md) | Pricing/packaging reference |

**Item format:** one line of what + why, then `where` (repo/file), `size` (S/M/L), `source`. Keep decided-but-unbuilt work in Now/Next; keep anything awaiting a decision in Parked.

---

## What users have told us

Evidence behind the items below. Full replies live in the [reply log](https://docs.google.com/spreadsheets/d/13gYQ7zthNXZv9A9tGT6Uhr6RBJuvAs3J5hrmGeb2Qqw/edit); this is the running summary. **1 reply so far** — under the ≥3-of-8 bar, so treat as signal, not a mandate.

**Reply 1 (2026-09-20, user 68 — churned, TRIAL, 0 workouts, one session):** `first-session`
- **Came for calisthenics.** That was the draw, and it's what the skill tree is.
- **"Lotta stuff on the app" → overwhelmed**, "didn't care to figure it out". Day one was demo data + an 11-step tour + a trial banner.
- **Perceived an immediate subscription paywall** — though nothing was actually locked for him; he was on an active trial. The paywall feel came from the banner (and on iOS, Upgrade opens Apple's purchase sheet in one tap).
- **Didn't want a second fitness subscription.** Already uses **Arrow Fitness** — free at first, he enjoyed it, its **Discord community** showed him other real users, and only then did he pay **$18/yr**.
- **His own suggestion:** "ease you in… most of the features free… then allowing for the choice to pay money and not be a necessity."

**Feedback 2 (2026-09-25, native mobile):** set logging is clunky. Tapping a weight/reps field opens the keyboard, which covers half the screen; you have to tap away to dismiss it, then repeat for the next value. Several other users have separately said the app has a lot going on and is hard to learn (see the first-session item in Next).

**Reading it:** overwhelm reports are about *activation* (people who never started); logging friction is about *retention* (people who did). Both point at the core loop, which is why the two items below are sequenced rather than competing.

**Reading reply 1:** the conversion pattern he describes is value → belonging → payment. TenXRep currently asks on day zero and runs a countdown whether or not value ever landed. Note he also got trial-reminder and winback emails having never logged a workout.

## Now

- [ ] **Delay the trial banner until the user's first logged workout (or day 3).**
  Today the banner renders on the dashboard from the first second: "Your free trial — 14 days remaining [Upgrade Now]". A new user is asked to pay before seeing any value. Interview reply (user 68) described the first session as "an immediate subscription paywall" even though nothing was locked for them.
  *where:* `tenxrep-web/src/components/TrialBanner.tsx`, mounted `src/pages/Index.tsx` · *size:* S · *source:* user interview 2026-09-20
  *measure:* PostHog activation funnel — first-workout rate before/after.

- [ ] **Mobile set-logging input friction — phase 1 (steppers, chips, typed fallback).**
  On native, every value entry opens the keyboard, which covers half the screen and has to be dismissed by tapping away. Decided approach: make the common path keyboard-free, keep typing as the fallback for weight. Increments below come from the 576 logged exercise rows, not guesses.
  1. **Remove the text input from reps and sets entirely** — steppers + chips only, so those fields can never open a keyboard. Weight is the sole exception (step 5). For the one remaining typed field, plus any other typed input in the logging flow, set `inputMode="decimal"`, `enterKeyHint="done"`, and blur on Enter so the keypad is compact and dismisses itself. Nothing in the app sets these today.
  2. **Fix the increments.** The weight stepper currently moves **±0.5 lb** (270 taps to reach 135). Of 416 non-zero weights logged, **338 are multiples of 5** and 379 of 2.5; only 37 need finer. So: **weight ±5 primary, 2.5 as a secondary/long-press**, reps **±1**.
  3. **Quick chips from real distributions.** Reps **8 / 10 / 12** (8 and 10 alone are ~60% of all values logged; then 12, 5, 20, 15, 3). Sets **2 / 3** (89% of rows). Weight chips optional — top values are 30, 45, 25, 52.5, 205.
     **Timed exercises need their own increments:** the reps field becomes "Duration (s)" when `is_timed` (45 such exercises in the library, 133 logged rows), and `hold_time` values run 3–60s, clustering at 10, 8, 30, 20, 60 — frequently *not* multiples of 5. So duration gets **±1 with a ±5 secondary** plus **10 / 30 / 60** chips. Don't leave duration on ±1 alone (60 taps) and don't force multiples of 5 (it would lose the 7s/8s/9s holds).
  4. **Add steppers/chips where they're missing.** The summary row has them; the surfaces people actually log on don't — the per-set breakdown rows (`ExerciseCard.tsx` ~1225–1275) and `RepsInputDialog` are bare `type="number"` inputs.
  5. **Keep tap-to-type for weight only** — the one field in the logging flow that can still open a keyboard, as the escape hatch for 52.5, 205, and the 37 sub-2.5 values. Everything else is taps.
  6. **"Same as last set" one-tap.** Last-session prefill already exists, so most logging should be confirmation, not entry.
  7. **Collapse the weight control when there's no weight — never hide it by exercise type.** Bodyweight exercises routinely become weighted (weighted pull-ups/dips, a dumbbell in a Bulgarian split squat): roughly **92 of 383 bodyweight-ish rows were logged with a weight** (approximate — 93 rows have empty `required_equipment`, and exercises like Elevated Pseudo Push-Up, Squats, and Standing Calf Raises show up weighted). So:
     - Default **collapsed behind "+ Add weight"** when the exercise has no weight in the last-session prefill (371 of 576 rows have no weight at all, so this is the common case and reps becomes the entire interaction).
     - Default **expanded** when prefill carries a weight, so weighted work costs no extra tap.
     - Always revealable in one tap. Never gate on `type`/`required_equipment` — that's what would break weighted calisthenics.
  8. Also check focus handling: no `scrollIntoView` on focus anywhere, and Capacitor keyboard resize mode is `KeyboardResize.Body` (`src/capacitor.ts:21`), which resizes the whole webview and causes the layout shift.
  *where:* `tenxrep-web/src/components/ExerciseCard.tsx` (~555–700 summary, ~1225–1275 per-set), `src/components/RepsInputDialog.tsx`, `src/capacitor.ts` · *size:* M · *source:* user feedback 2026-09-25
  *measure:* sets logged per session and mid-workout abandonment; `workout_logged` in PostHog.

- [ ] **Stop sending trial-reminder / winback emails to users who never activated.**
  User 68 logged zero workouts and still got the 1-day reminder and the winback. With 53 ghosts on the list, "your trial is ending" is the wrong email for people who never started — either skip them or send a different one.
  *where:* `tenxrep-api` trial-reminder cron (`cron.py`, `/internal/trial-reminders/run`) · *size:* S · *source:* user interview 2026-09-20

- [ ] **iOS: don't open Apple's purchase sheet on the first tap.**
  `handleUpgrade` calls `purchase()` directly on iOS, so one tap on the banner raises a native payment dialog. Put a "what Pro includes" screen in front of it so a purchase dialog requires intent.
  *where:* `tenxrep-web/src/components/TrialBanner.tsx` · *size:* S · *source:* user interview 2026-09-20

## Next

- [ ] **Simplify the first session (progressive disclosure) — don't cut features.**
  Multiple users report the app is overwhelming to learn. The data says the problem is *how much is shown before anyone has done anything*, not the feature count: day one presents a dashboard with ~27 top-level controls, 5 nav destinations, demo data that isn't theirs, an 11-step tour, and a trial countdown — before a single set is logged. Meanwhile engaged users do use the depth (9 of 18 loggers use the skill tree; 5 of the 7 with 3+ workouts), so subtracting features would remove what retains people.
  Scope:
  1. Land new users on an obvious empty state ("add your first exercise") instead of demo data.
  2. Hold back secondary surfaces (Volume/Balance modes, recommendations, stats depth) until a workout exists.
  3. Reveal the 3D model as the payoff right after the first logged set — the existing `model_lit_first_time` event marks it.
  4. Stop auto-prompting the 11-step tour; keep it behind the help icon.
  **Leave the skill tree prominent** — it's the acquisition draw (interview reply 1 came for calisthenics) and half of all loggers use it.
  *where:* `tenxrep-web/src/pages/Index.tsx` (2,144 lines — split as part of this), `src/components/tutorial/*` · *size:* M · *source:* interview reply 1 + several users' feedback, 2026-09-20
  *measure:* PostHog funnel ① activation rate, and first-workout rate for new signups, before/after. Cohort caution: Apr–May activated 9/32, Jul–Sep 1/18 after June added first-session surface — small n, channel may also have shifted.
  *sequence:* ship the trial-banner delay (Now) first, so the two changes can be measured apart.

- [ ] **Ship a native build carrying the OAuth-only auth UX.**
  Web main hides the open username signup form on native and routes forgot-password to web; the last iOS release (06-23) predates it, so existing installs still show the username form and get a 403 once Turnstile enforces.
  *where:* `tenxrep-web` native build + App Store release · *size:* M · *source:* TURNSTILE_ROLLOUT.md

- [ ] **Cap verification-email resends per pending signup.**
  `POST /auth/resend-verification` isn't CAPTCHA-gated; its only limits are a 2-minute per-email cooldown and 3/min per IP. One solved CAPTCHA can therefore send ~720 emails to one address over a pending signup's 24h life. A total-resend cap (e.g. 3) is platform-agnostic and needs no widget.
  *where:* `tenxrep-api/app/api/v1/endpoints/auth.py` (+ migration for the counter) · *size:* S · *source:* security review 2026-09-10

- [ ] **Send the real client IP to Turnstile.**
  `verify_turnstile_token` passes `request.client.host`, which behind App Runner is the proxy. Use the `get_client_ip` helper the rate limiter already uses.
  *where:* `tenxrep-api/app/services/turnstile.py`, `app/core/limiter.py` · *size:* S · *source:* security review 2026-09-10

- [ ] **Monitor Gmail sender reputation (Google Postmaster Tools).**
  Post-abuse follow-up. If reputation is dented, isolate the verification-email sender onto a subdomain so the root domain recovers.
  *where:* DNS + Resend config · *size:* M · *source:* TURNSTILE_ROLLOUT.md

- [ ] **Outreach follow-through.** 9 recipients are on `@privaterelay.appleid.com` and can't be emailed from personal Gmail (Apple only accepts registered senders) — check Resend logs for delivery to a relay address to learn whether `tenxrep.com` is already registered. Also review user ids 70, 88, 91 (pre-opt-in signups, no setup, never returned — possible unflagged bots).
  *where:* Apple Developer portal / admin · *size:* S · *source:* outreach prep 2026-09-11

## Later

- [ ] **Mobile set logging — phase 2: drum picker for weight (only if phase 1 isn't enough).**
  Conditional follow-up to the phase-1 item in Now. A bottom-sheet wheel/drum picker (as in Hevy/Strong) replaces typed weight entry: flick to any value, no keyboard, and the reel only offers valid steps so 52.5 and 205 cost the same as 25. **Trigger for doing it:** users still report keyboard friction after phase 1 ships, or typed entry stays common in practice.
  Notes if built: reel needs momentum scrolling + haptic notches (no native picker in a Tailwind/shadcn app — it's a CSS scroll-snap list); 0–500 in 2.5 steps is ~200 stops, so consider a coarse/fine split; keep a small keypad fallback inside the sheet for accessibility (VoiceOver, large text) and odd values. **Reps stay on chips** — they cluster in a narrow range, so a wheel would be slower than one tap.
  *where:* `tenxrep-web/src/components/ExerciseCard.tsx`, new picker component · *size:* L · *source:* design discussion 2026-09-25

- [ ] **`workout_exercises.is_weighted` is unreliable — decide whether it's the source of truth or drop it.**
  The flag is true on only **29 of 576 rows**, while **175 rows carry a non-zero weight without it set**. The frontend ignores the column entirely and derives weighted-ness instead (`ExerciseCard.tsx:307`: `type === 'free' || type === 'machine' || (type === 'body' && weight > 0)`), using it only to render a "Weighted {type}" label. So the DB column and the UI disagree about what "weighted" means. Either populate it wherever a weight is entered and read from it, or delete it and derive consistently. Worth settling before the set-logging work leans on it for the "+ Add weight" default state.
  *where:* `tenxrep-api/app/models/workout.py`, `tenxrep-web/src/components/ExerciseCard.tsx`, `src/pages/Index.tsx:370`, `src/hooks/useAddToTodayWorkout.ts` · *size:* S–M · *source:* observed 2026-09-25

- [ ] **Delete the dead `POST /recommendations/week` endpoint.** Fully built, no frontend wiring, unreachable by any user. Remove route + `WeekRecommendation*` schemas + tests.
  *where:* `tenxrep-api/app/api/v1/endpoints/recommendations.py:100` · *size:* S · *source:* 2026-06-12 decision

- [ ] **Stripe dashboard email toggles (no code).** Enable "Email customers for failed payments" (dunning) and "for successful payments" (receipts). Apple sends its own.
  *where:* Stripe Dashboard → Settings → Emails · *size:* S

- [ ] **Remaining transactional emails.** Activity-based re-engagement (14+ days since last workout — scheduler already exists), email-changed confirmation (needs a change-email endpoint), OAuth-account-linked notice, new-device/suspicious login (largest lift).
  *where:* `tenxrep-api/app/services/email_service.py` · *size:* M

- [ ] **PostHog funnels ②–④.** Setup opt-in, legacy wizard drop-off, weekly first-workout trend. Funnel ① (activation) is built.
  *where:* PostHog UI, no code · *size:* S

- [ ] **Staging consistency.** Redeploy staging web from main and reconcile the staging Turnstile secret.
  *size:* S

- [ ] **Work the audit backlog.** 16 open findings — dependency bumps, `beta_signups` PII on account deletion, auth error-message enumeration, rate limits on authenticated writes, request body size limit, slowapi in-memory storage, coverage tooling, oversized components, one-off scripts cleanup.
  *where:* [AUDIT_FINDINGS.md](../AUDIT_FINDINGS.md) · *size:* L

## Parked — awaiting the interview decision gate

Don't build these until ~8 replies are in and one blocker category has ≥3 (see [user-interview-plan.md](user-interview-plan.md)).

- **Rework the first session.** If replies cluster on `first-session`: a guided path to one logged workout instead of demo data + an 11-step tour.
- **Reshape free vs paid.** If replies cluster on pricing/paywall feel: full features first, then a genuine free tier, rather than a 14-day countdown that starts on day zero.
- **Become the visualization layer over other trackers.** If replies cluster on `already-use-other`: import from Hevy/Strong/Apple Health, which also removes the empty day-one state.
- **Change acquisition channel.** If replies cluster on `low-intent`.

## Decided against — don't re-propose

- **Removing or burying exercise favorites.** Only 3 of 18 loggers have ever favorited an exercise, so it came up as a deletion candidate during the 2026-09-21 simplification discussion. **Decision: keep as-is.** Simplification work targets first-session sequencing, not feature removal.

## From other sessions — to triage

<!-- Paste items here; move them into Now/Next/Later with where/size/source once triaged. -->
