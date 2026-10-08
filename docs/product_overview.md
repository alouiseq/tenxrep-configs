# TenXRep — Product Overview

> **Purpose:** the single, self-contained description of what TenXRep is and does today. Written to be pasted into another AI (ChatGPT, Gemini, Claude, Grok…) or handed to anyone outside the codebase. It describes **current state only**; for change history see the [marketing changelog](https://tenxrep.com/changelog), for planned work see `backlog.md`.
>
> **Last verified:** 2026-10-07 — counts below come from the production database, gates from the app code.
>
> **Keep it current:** when a user-facing feature ships, update this file in the same wrap-up as the changelog entry.

---

## 1. One-liner

**TenXRep is a workout tracker with an interactive 3D anatomy model: as you log exercises, the model lights up the muscles you trained, so you can see what your program is actually doing — which muscles are over- or under-worked, and how you're progressing toward calisthenics skills.**

Positioning category: *"Visual Training Intelligence."* Strong/Hevy/JEFIT track sets but show no anatomy; Muscle & Motion / iMuscle show anatomy but don't track workouts. TenXRep combines both.

## 2. Who it's for

- **Calisthenics practitioners** working toward skills (planche, front lever, muscle-up, handstand…). This is the strongest acquisition draw so far.
- **Lifters / hybrid trainees** who want to check their program is balanced (push vs pull, front vs back).
- People who want evidence-based muscle-targeting data rather than guesses.

During setup the user picks a focus — **Resistance Training, Calisthenics, or Hybrid** — which tailors recommendations and navigation (e.g. the Skills page is surfaced for Calisthenics/Hybrid).

## 3. Platforms & availability

| Platform | Status | Payments |
|---|---|---|
| Web app — app.tenxrep.com | Live (responsive: desktop, tablet, mobile browser) | Stripe |
| iOS (iPhone + iPad) | Live on the App Store | Apple In-App Purchase |
| Android | Native shell built, **not yet published** | — |
| Marketing site — tenxrep.com | Live (features, pricing, FAQ, blog, changelog) | — |

Sign-in: email + password (with email verification), Google, and Sign in with Apple (iOS). Accounts can link multiple sign-in methods. One account works across web and iOS.

## 4. Core features

### 4.1 Workout tracking
- Log workouts by day: exercises, sets, reps, weight — or **hold duration** for timed/isometric exercises.
- Per-set breakdown, weighted vs bodyweight variants (e.g. weighted dips), equipment options (e.g. parallettes).
- **Last Session comparison** — each exercise shows how you did last time (reps per set and weight) and pre-fills from it.
- **Auto-save** of in-progress workouts (survives crashes, closed tabs, iOS backgrounding).
- Copy workouts, calendar view with workout-day indicators, personal records page.
- Add an exercise to today's workout in one tap from the **exercise library**, the **3D muscle view**, or a **skill-tree node**.
- Mobile set-logging redesign (steppers and quick-pick chips instead of the keyboard) is **in progress**.

### 4.2 Exercise library
- **250 built-in exercises** (126 of them calisthenics), plus user-created custom exercises.
- Organized into **9 muscle groups** (Chest, Back, Deltoids, Biceps, Triceps, Forearms, Core, Legs, Glutes) and **36 specific target muscles** (e.g. upper chest, rear delts, lats, adductors).
- Each exercise lists its target muscles with an **activation level** (maximal / high / medium / low). Activation data is sourced from peer-reviewed EMG studies or evidence-based coaches (e.g. Jeremy Ethier, FitnessFAQs) — not invented.
- Filter by muscle group, target muscle, weight type (free weights / bodyweight / machine), calisthenics skill, default vs custom; search; sort.
- Demo media (images / YouTube videos) and favorites.
- Tap an icon on any exercise to light up its muscles on the 3D model instantly, without logging it.

### 4.3 3D anatomy model
- Interactive, rotatable 3D body: **237 muscle meshes**, 40+ sub-muscles.
- **Simple mode** (colors by the 9 muscle groups) and **Advanced mode** (individual sub-muscles).
- Three view modes over the current week's training:
  - **Activation** — which muscles were hit and how hard.
  - **Volume** — weekly set volume per muscle, against recommended ranges.
  - **Balance** — warm/cool color map of **push vs pull** and **anterior vs posterior** volume, with per-muscle breakdowns.
- **Visual Progression** — a timeline slider to scrub back through past weeks on the model.
- Tap a muscle to see exercises that target it and add one to today's workout.
- Desktop: side-by-side dashboard + 3D panel. Mobile: full-screen panel with a live mini-preview thumbnail.

### 4.4 Imbalance detection & corrective programs
- Flags push/pull and front/back imbalances from logged volume.
- Suggests **corrective micro-programs** — short, targeted exercise sets for the under-trained muscles.
- **Overtraining "Red Zone"** alerts when a muscle exceeds **30 weekly sets**.

### 4.5 Workout recommendations
- Three setup styles: **Recommend Entire Workout** (fully automatic), **Select Targeted Muscle Groups on Days** (partial), or **Manual**.
- Split types: Upper/Lower, Push/Pull/Legs, Per Muscle Group, Calisthenics Techniques.
- Recommendations include sets, reps, rest, and **progressive-overload suggestions** (e.g. "increase to 27.5 lbs — you hit 5+ reps on all sets").
- Swap any single recommended exercise for an alternative.

### 4.6 Calisthenics skill tree
- **15 skills, 91 progressions**, from beginner to elite:

| Category | Skills (progressions) |
|---|---|
| Pushing | Planche (12), Handstand Push-Up (7), One-Arm Push-Up (4), Dips (4) |
| Pulling | One-Arm Pull-Up (8), Muscle-Up (6) |
| Isometric | Front Lever (12), Handstand (7), Back Lever (6), L-Sit (5), Human Flag (5), Advanced Handstand (4), Dragon Flag (4), Skin the Cat (3) |
| Legs | Pistol Squat (4) |

- **Radial view** (default): a segmented donut per category, progressions radiating outward; plus a **classic column view**.
- Progress is automatic: logging a qualifying set of a linked exercise counts toward mastery (each progression has a goal, e.g. "15 reps × 5 sets"). Three states: mastered / in progress / locked; the next progression to work on pulses.
- Skill detail drawer: description, level, progression path with mastery dates, personal best per progression.
- Weekly stat: "skill progressions hit this week"; mastery celebrations after a workout.

### 4.7 Progress & stats
- Progress page with charts of training by muscle group over time.
- Personal records per exercise.
- Weekly stats strip on the dashboard.

### 4.8 Onboarding
- New users land straight on the dashboard with a sample workout lighting up the 3D model (removed once they log a real workout).
- Optional setup wizard (focus, split, training days, recommendation style) offered via a dismissible banner.
- Optional guided tour.

## 5. Pricing & free vs Pro

- **Pro:** $4.99/month or $34.99/year. Every new account gets a **14-day Pro trial, no card required**. After the trial, the account falls back to Free (no hard lockout).
- Billing: Stripe on web (with self-serve billing portal), Apple IAP on iOS.

| Feature | Free | Pro / Trial |
|---|---|---|
| Unlimited workout tracking | ✅ | ✅ |
| Full exercise library + per-exercise 3D preview | ✅ | ✅ |
| 3D Activation view (Simple mode) | ✅ | ✅ |
| Custom exercises | Up to 5 | Unlimited |
| 3D Advanced mode (sub-muscles) | — | ✅ |
| Volume view & Balance view | — | ✅ |
| Visual Progression timeline | — | ✅ |
| Corrective micro-programs | — | ✅ |
| Workout recommendations (incl. progressive overload) | — | ✅ |
| Skill tree progression tracking | — | ✅ |

Design principle: *gate depth, not surface* — free users see **what** an exercise trains; Pro shows **how balanced your training is over time**.

## 6. Not built (avoid assuming these exist)

- No Android store release yet.
- No wearable / Apple Health / Google Fit integration, and no import from other trackers (Strong, Hevy).
- No data export.
- No social feed, community, or coaching marketplace.
- No AI chat coach; recommendations are rule-based.
- No nutrition tracking.

## 7. Current stage & direction

- Early-stage, solo-built product with a small user base. Current focus is **activation and retention** rather than new features: simplifying the first session, making mobile set logging keyboard-free, and delaying the trial-countdown banner.
- Under consideration (not decided): repositioning to lead with calisthenics (3D as the proof), and moving part of the skill tree into the free tier.
- Next substantial feature candidate: a **skill readiness score** ("you're 60% ready for a muscle-up") built from logged volume and the skill tree's prerequisites.

## 8. Tech stack (for technical readers)

- **Web app:** React 18, TypeScript, Vite, Tailwind + shadcn/ui, TanStack Query, Three.js / React Three Fiber — hosted on Vercel.
- **Mobile:** Capacitor native shells (iOS live, Android built).
- **API:** FastAPI (Python 3.11), SQLAlchemy, Alembic, PostgreSQL (Neon) — AWS App Runner.
- **Marketing site:** Next.js 14 — Vercel.
- **Services:** Stripe, Apple IAP (StoreKit 2), Resend (email), PostHog (analytics), Sentry (errors), Cloudflare Turnstile (bot protection).
