# TenXRep Backlog

Single list of planned work across all four projects. Add items here rather than leaving them in session notes.

**Specialized trackers this doc links to, not duplicates:**

| Tracker | Scope |
|---|---|
| [tenxrep_strategy.md](tenxrep_strategy.md) | **Positioning, diagnosis, growth — the *why*.** Source for the repositioning, readiness-score, content and distribution items below. This doc owns trackable items; where the two disagree, decisions recorded here win. |
| [audit_findings.md](../audit_findings.md) | Security/quality audit (16 open, 8 fixed) |
| [turnstile_rollout.md](../turnstile_rollout.md) | Email-abuse mitigation — done, 3 open items pulled in below |
| [user_interview_plan.md](user_interview_plan.md) | Interview campaign + decision gate |
| [product_overview.md](product_overview.md) | What the app does today — features, pricing, free vs Pro |

**Item format:** one line of what + why, then `where` (repo/file), `size` (S/M/L), `source`. Keep decided-but-unbuilt work in Now/Next; keep anything awaiting a decision in Parked.

## Working agreement — state the intent before building

**Before starting any item, summarize the intent — *what* the change is and *why* — and wait for a green light or pushback.** Keep it short (a few lines, not a spec): the user-visible behaviour change, the reasoning, and any judgement call being made on the user's behalf. Then build.

Why: the point is to catch wrong-shaped work before it's written, not after. The trial-banner item is the worked example — the first implementation gated the banner on "has logged a workout, or day 3"; stating that intent surfaced a better rule ("don't show until the last few days of the trial"), which was both simpler and closer to what was actually wanted. That correction cost one message instead of a discarded branch.

Applies to items already recorded here too — being in Now/Next means the *problem* is agreed, not that the approach is.

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

- [x] ~~**Delay the trial banner until the last few days of the trial.**~~ **SHIPPED** (web #53, 2026-09-27). Shows at 5 days left, urgent styling at 3; expired always shows. Rule in `src/lib/trialBanner.ts`.
  Today the banner renders on the dashboard from the first second: "Your free trial — 14 days remaining [Upgrade Now]". A new user is asked to pay before seeing any value. Interview reply (user 68) described the first session as "an immediate subscription paywall" even though nothing was locked for them.
  **Decided rule (2026-09-27):** show at **5 days left**, escalate to the existing urgent styling at **3**; an expired trial always shows. Nothing else changes.
  Why a time gate rather than "after the first logged workout": simpler (no extra data dependencies), and "11 days remaining" was never actionable — the early banner was noise with a payment button attached. Nothing is lost, because trial status stays visible in Settings (`SettingsView.tsx:475`) and the reminder emails fire at 7, 2 and 1 days left. The two constants are also the knob to widen if conversion, rather than activation, becomes the bottleneck.
  *where:* `tenxrep-web/src/components/TrialBanner.tsx`, mounted `src/pages/Index.tsx` · *size:* S · *source:* user interview 2026-09-20
  *measure:* PostHog activation funnel — first-workout rate before/after.

- [x] ~~**Mobile set-logging input friction.**~~ **SHIPPED in three parts** (web #54, #60, #61 — all mobile-only). **1a:** numeric `inputMode`/`enterKeyHint`/blur-on-Enter so the keypad is compact and self-dismissing; weight step 0.5 → 5. **2a:** duration coarse ±5 + 10/30/60 presets, `DEFAULT_HOLD_SECONDS` 30 → 10, per-set weight aligned to ±5, steppers in `RepsInputDialog`. **2b:** every stepper labelled with its magnitude (device feedback: identical icons moving by 5 vs 1 read as a bug), secondary weight ±10/±2.5, weight collapsed behind "+ Add weight" with an × to clear. Logic in `src/lib/setLogging.ts`.
  *Deliberately not done, with reasons recorded:* reps/sets presets (defaults 8/3 are already the modes, so 0 taps in the common case), removing the reps/sets text inputs (1a fixed the keyboard trap, and reps has a long tail at 20/15/3 that ±1 alone would worsen), ±25 weight step (zero logged changes; plates load in pairs on a bar), and "same as last set" (per-set rows already propagate forward).
  On native, every value entry opens the keyboard, which covers half the screen and has to be dismissed by tapping away. Decided approach: make the common path keyboard-free, keep typing as the fallback for weight. Increments below come from the 576 logged exercise rows, not guesses.
  **Split into two PRs. Phase 1a is in review (web PR #54) — steps 2 (increments) and the keyboard-attribute half of step 1 are done and manually verified; everything below is what's left.**
  Still outstanding from 1a, both descoped because they need on-device testing: a **±5 secondary increment for duration** (needs a second control, i.e. a layout change — fold into the chips work), and **`scrollIntoView` on focus + the Capacitor `KeyboardResize.Body` mode** (affects every screen).
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
     - **Don't gate on `can_be_weighted` either** (checked 2026-09-27). It looks like the right flag and isn't: it's true on only **20 of 251** library exercises, and of the 81 BODY/RINGS rows actually logged *with* a weight, **56 sit on exercises whose library row says `can_be_weighted = false`** — Parallel Bar Dip (17), Elevated Pseudo Push-Up (11), Single-Leg Hip Thrust, Standing Calf Raises. Gating on it hides the affordance for the most commonly weighted calisthenics moves. Same failure mode as gating on `type`, one layer down. (`is_weighted` is out too — see its own item below.)
     - **The toggle has to work both ways.** Prefill answers "show weight?", but nothing yet answers "remove weight". Did weighted dips last week, going bodyweight today → prefill shows 25 and the only exit is five taps of `−`. Needs an × (or a tap on the label) that clears the weight to 0 and re-collapses.
  8. Also check focus handling: no `scrollIntoView` on focus anywhere, and Capacitor keyboard resize mode is `KeyboardResize.Body` (`src/capacitor.ts:21`), which resizes the whole webview and causes the layout shift.
  *where:* `tenxrep-web/src/components/ExerciseCard.tsx` (~555–700 summary, ~1225–1275 per-set), `src/components/RepsInputDialog.tsx`, `src/capacitor.ts` · *size:* M · *source:* user feedback 2026-09-25
  *measure:* sets logged per session and mid-workout abandonment; `workout_logged` in PostHog.

- [ ] **Stop sending trial-reminder / winback emails to users who never activated.**
  User 68 logged zero workouts and still got the 1-day reminder and the winback. With 53 ghosts on the list, "your trial is ending" is the wrong email for people who never started — either skip them or send a different one.
  *where:* `tenxrep-api` trial-reminder cron (`cron.py`, `/internal/trial-reminders/run`) · *size:* S · *source:* user interview 2026-09-20

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

- [x] ~~**Fix marketing copy inconsistencies.**~~ **SHIPPED** (marketing #6 + #8). Verified real numbers: the DB has **251 exercises**, **15 skills**, **91 progressions**. The site says 206+ in features vs 160+ in the free tier (both wrong), and 14 skills in features vs 15 in pricing (pricing is right). Also: "TenxRep" casing in the workout-recommendations section, and the FAQ "Is TenXRep available now?" makes the product sound unfinished — drop it. Note the monorepo CLAUDE.md also says 160+ exercises and 88 progressions; update it too.
  *where:* `tenxrep-marketing`, root `CLAUDE.md` · *size:* S · *source:* strategy §4
  *not blocked by the repositioning hold* — wrong counts and inconsistent brand casing are factual errors regardless of which direction the positioning lands.

- [ ] **Ship a native build — HIGHEST PRIORITY as of 2026-10-09.** Two reasons:

  **1. iOS username signup has been broken since 2026-08-26.** Turnstile enforcement went live that day and web #47 (which hides the open username form on native and routes forgot-password to web) shipped the same day — but native bundles a *copy* of the web app, so that steering never reached users. The App Store build is **1.3.0 (8), 2026-06-23**, which still renders the username form; the API now rejects it with **403**. Google/Apple sign-in are unaffected, so it's a broken path rather than a broken app.

  **2. Nothing from the last two weeks has reached a user.** All of it is on `main` only: trial-banner delay (#53), set-logging 1a/2a/2b (#54/#60/#61). The set-logging work exists *because* a native user complained, and they cannot receive it without an App Store release.

  **Readiness (verified 2026-10-09):** `main` is buildable. `.env.production.local` has `VITE_API_BASE_URL`, `VITE_ENVIRONMENT`, `VITE_SENTRY_DSN`, PostHog, Google, Stripe. `VITE_TURNSTILE_SITE_KEY` is correctly **absent** — native hides the username form, so no widget is needed and the invite flow isn't CAPTCHA-gated.

  **Steps:** `npm run build` → `npx cap sync ios` → bump `MARKETING_VERSION`/`CURRENT_PROJECT_VERSION` to **1.3.1 / 9** (bug fixes and ergonomics, no new features) → verify in the bundle that the native register screen has no username form, forgot-password routes to web, the API URL is production, and `VITE_ENVIRONMENT=production` (PostHog mislabels prod users as dev otherwise — see `reference_posthog_data_reliability`). Then Xcode: signing, archive, upload, submit. **Claude can do everything up to Xcode; the user does Xcode and submission.**
  *where:* `tenxrep-web` native build + App Store release · *size:* M · *source:* turnstile_rollout.md, session 2026-10-09

- [ ] **Cap verification-email resends per pending signup.**
  `POST /auth/resend-verification` isn't CAPTCHA-gated; its only limits are a 2-minute per-email cooldown and 3/min per IP. One solved CAPTCHA can therefore send ~720 emails to one address over a pending signup's 24h life. A total-resend cap (e.g. 3) is platform-agnostic and needs no widget.
  *where:* `tenxrep-api/app/api/v1/endpoints/auth.py` (+ migration for the counter) · *size:* S · *source:* security review 2026-09-10

- [ ] **Send the real client IP to Turnstile.**
  `verify_turnstile_token` passes `request.client.host`, which behind App Runner is the proxy. Use the `get_client_ip` helper the rate limiter already uses.
  *where:* `tenxrep-api/app/services/turnstile.py`, `app/core/limiter.py` · *size:* S · *source:* security review 2026-09-10

- [ ] **Monitor Gmail sender reputation (Google Postmaster Tools).**
  Post-abuse follow-up. If reputation is dented, isolate the verification-email sender onto a subdomain so the root domain recovers.
  *where:* DNS + Resend config · *size:* M · *source:* turnstile_rollout.md

- [ ] **Outreach follow-through.** 9 recipients are on `@privaterelay.appleid.com` and can't be emailed from personal Gmail (Apple only accepts registered senders) — check Resend logs for delivery to a relay address to learn whether `tenxrep.com` is already registered. Also review user ids 70, 88, 91 (pre-opt-in signups, no setup, never returned — possible unflagged bots).
  *where:* Apple Developer portal / admin · *size:* S · *source:* outreach prep 2026-09-11

## Later

- [ ] **Skill readiness score (strategy §7.1) — first genuinely new feature.**
  Turn logged volume into a percentage toward each skill ("you're 60% ready for a muscle-up"). Most of the work exists: the tree already has prerequisite progressions with concrete thresholds, so this surfaces that checklist as one number. Strongest retention lever, because calisthenics skills take months and a number that ticks up weekly gives progress on days the skill hasn't moved.
  **Verified prerequisite:** the skill tree is **not currently linked to imbalance/volume data** — 0 references to balance or volume-history data across every skill component (`CategoryColumn`, `RadialSkillTree`, `SkillDetailPanel`, `SkillTreeView`, `SkillTree.tsx`), and no readiness or weak-link code in the API. That linkage is the build, and it answers strategy §2's open question.
  Include the "prerequisites met but still can't do it" case (§7.1): when all prerequisites clear and the skill still isn't happening, say strength likely isn't the limiter and offer the 3D weak-link view plus a technique checklist.
  *where:* `tenxrep-api` (new endpoint + scoring), `tenxrep-web/src/components/skills/*` · *size:* L · *source:* strategy §7.1, Step 3

- [ ] **Distribution: go where the audience already is (strategy §8–§9).** Non-code. Content reframe from "post the attempt" to "post the diagnosis"; platform split (TikTok skill content, YouTube age angle, separate Instagram account); calisthenics subreddits by answering questions rather than launch posts; **Bay Area Bars Calisthenics is the best single contact** (has an organizer and a real community). Detail lives in the strategy doc — not broken into items here.
  *size:* ongoing · *source:* strategy §8–§9

- [ ] **Later-not-now features (strategy §7.2–§7.5).** Prescriptive linking, weak-link detection from failed reps, video capture tied to skill nodes, adaptive programs. All wait on the day-one drop-off being fixed; adaptive programs also wait on retention existing.
  *source:* strategy §7

- [ ] **Mobile set logging — drum picker for weight (only if the labelled steppers aren't enough).**
  *Trigger revised 2026-10-09:* 2b labelled the steppers and added ±10/±2.5, which addressed the reported friction without a new control. Build this only if typed weight entry stays common in practice or keyboard friction is reported again.
  Conditional follow-up to the phase-1 item in Now. A bottom-sheet wheel/drum picker (as in Hevy/Strong) replaces typed weight entry: flick to any value, no keyboard, and the reel only offers valid steps so 52.5 and 205 cost the same as 25. **Trigger for doing it:** users still report keyboard friction after phase 1 ships, or typed entry stays common in practice.
  Notes if built: reel needs momentum scrolling + haptic notches (no native picker in a Tailwind/shadcn app — it's a CSS scroll-snap list); 0–500 in 2.5 steps is ~200 stops, so consider a coarse/fine split; keep a small keypad fallback inside the sheet for accessibility (VoiceOver, large text) and odd values. **Reps stay on chips** — they cluster in a narrow range, so a wheel would be slower than one tap.
  *where:* `tenxrep-web/src/components/ExerciseCard.tsx`, new picker component · *size:* L · *source:* design discussion 2026-09-25

- [ ] **`workout_exercises.is_weighted` is unreliable — decide whether it's the source of truth or drop it.**
  The flag is true on only **29 of 576 rows**, while **175 rows carry a non-zero weight without it set**. The frontend ignores the column entirely and derives weighted-ness instead (`ExerciseCard.tsx:307`: `type === 'free' || type === 'machine' || (type === 'body' && weight > 0)`), using it only to render a "Weighted {type}" label. So the DB column and the UI disagree about what "weighted" means. Either populate it wherever a weight is entered and read from it, or delete it and derive consistently. Worth settling before the set-logging work leans on it for the "+ Add weight" default state.
  *where:* `tenxrep-api/app/models/workout.py`, `tenxrep-web/src/components/ExerciseCard.tsx`, `src/pages/Index.tsx:370`, `src/hooks/useAddToTodayWorkout.ts` · *size:* S–M · *source:* observed 2026-09-25

- [ ] **iOS: don't open Apple's purchase sheet on the first tap.** *(moved down 2026-09-27 — largely defused.)*
  `TrialBanner.handleUpgrade` calls `purchase()` directly on iOS, so one tap raises a native payment dialog. That was a day-one problem when the banner rendered from the first session; now that it only appears at 5 days left (web PR #53), a brand-new user can't reach it, and `showUpgradeToast` already routes iOS users to Settings rather than purchasing directly. A user at day 5+ still gets a one-tap dialog, so it's not zero — put a "what Pro includes" step in front of it so a purchase dialog requires intent.
  *where:* `tenxrep-web/src/components/TrialBanner.tsx` · *size:* S · *source:* user interview 2026-09-20

- [ ] **Give the icon-only stepper buttons accessible names.** The ±  buttons on the mobile weight/reps/sets steppers are icon-only with no `aria-label`, so a screen reader announces them as unlabelled buttons. Noticed while testing them (had to query by DOM position instead of by name). Small, and worth doing as part of a wider a11y sweep rather than alone.
  *where:* `tenxrep-web/src/components/ExerciseCard.tsx` · *size:* S · *source:* observed 2026-09-27

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
  *where:* [audit_findings.md](../audit_findings.md) · *size:* L

## Parked — awaiting the interview decision gate

Don't build these until ~8 replies are in and one blocker category has ≥3 (see [user_interview_plan.md](user_interview_plan.md)).

- **Reposition: lead with calisthenics, 3D as proof (strategy §3–§4).** **HELD 2026-09-26 pending more interview replies.**
  Homepage, App Store listing, and short-form video framing. Current hero leads with technology ("See Your Muscles in 3D") and competes with Muscle & Motion, which is 1,200+ exercises deep on anatomy. Shift to naming the outcome ("know exactly why your muscle-up isn't happening yet"), reorder the page so skill tree is first and the exercise library last, and make it fully calisthenics-first with one line for lifters. Strategy §3 is explicit that half-narrowing doesn't work.
  *specific gate:* do replies mention calisthenics or the skill tree **unprompted**? 1 of 1 so far does ("downloading the app for calisthenics training") — supportive, but a repositioning on a single data point is a guess. Strategy Step 0: don't move past the interviews blind.
  *where:* `tenxrep-marketing` · *size:* M · *source:* [tenxrep_strategy.md](tenxrep_strategy.md) §3–§4, Step 2

- **Rework the first session.** If replies cluster on `first-session`: a guided path to one logged workout instead of demo data + an 11-step tour.
- **Reshape free vs paid.** If replies cluster on pricing/paywall feel: full features first, then a genuine free tier, rather than a 14-day countdown that starts on day zero.
  Strategy §4 has a concrete proposal — move one or two complete skills (or the first few progressions of every skill) into Free, keep the *diagnosis* layer paid (imbalance analysis, readiness score, corrective programs). Rationale: hook people on the tree, charge for the answer to "why am I stuck?" Today the skill tree, Balance View, Volume View and corrective programs are all Pro-only, so a free user gets a logger plus basic 3D — which is the product Strong and Hevy already do better. Still parked because strategy Step 0 says don't move past the interviews blind, and unlocking changes trial conversion.
- **Become the visualization layer over other trackers.** If replies cluster on `already-use-other`: import from Hevy/Strong/Apple Health, which also removes the empty day-one state.
- **Change acquisition channel.** If replies cluster on `low-intent`.

## Decided against — don't re-propose

- **Removing or burying exercise favorites.** Only 3 of 18 loggers have ever favorited an exercise, so it came up as a deletion candidate during the 2026-09-21 simplification discussion. **Decision: keep as-is.** Simplification work targets first-session sequencing, not feature removal.

## From other sessions — to triage

<!-- Paste items here; move them into Now/Next/Later with where/size/source once triaged. -->
