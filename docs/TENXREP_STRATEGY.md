# TenXRep — Positioning & Product Strategy

> Single source of truth for positioning, growth, and product priorities — the *why* behind the work.
> Trackable items (file paths, sizes, checkboxes) live in [BACKLOG.md](BACKLOG.md), which links back to the sections here. **Where the two disagree, a decision already recorded in BACKLOG.md wins** — this doc is the argument, not the work queue.

**Last updated:** 2026-09-26

---

## 1. Current state

Product is built and live on the App Store. Installs trickle in from short-form video (TikTok, YouTube Shorts, Instagram), but retention is near zero and nobody is paying. Typical pattern: install → open → maybe log one workout → gone.

In progress: hand-emailing every existing user to find out why. Highest-signal work currently happening.

From the outside, TenXRep is effectively invisible in search — no community chatter, no indexed reviews. The homepage is the only real footprint. Not fatal, just early.

---

## 2. The core diagnosis

### What's actually differentiated (ordered by distinctiveness)

1. **Calisthenics skill tree** — gamified progression toward skills, video-game inspired. Most distinctive asset. Currently buried in marketing and locked behind the paywall.
2. **Imbalance analysis** — primary *and* secondary muscle activation over time, over/under-training flags, anterior vs posterior balance, corrective micro-programs.
3. **3D visualization** — the hook, but not the moat.
4. **Workout logger** — table stakes. Not a differentiator.

### Competitive reality

Neither the skill tree nor the 3D view is unique on its own.

**3D anatomy competitors:**

| App | What it is | Pricing |
|---|---|---|
| Muscle & Motion | Education/reference library. 1,200+ exercises, weekly updates, prime movers / synergists / stabilizers / antagonists. Aimed at trainers, coaches, physios, students. | ~$15–$89 |
| Muscle Map AI | Recently launched. AI coaching + tracking + interactive 3D anatomy. | — |
| VisualBody Lab | Free 3D anatomy and biomechanics tools. | Free |

**Calisthenics skill-tree competitors:**

| App | Notes |
|---|---|
| Calistree | Visual skill-tree system, 1,300+ exercises. Top pick for planche / lever / muscle-up. |
| Calistack | "The Skill Tree System." First push-up → planche, handstand, front lever, muscle-up. |
| Calisteniapp | Largest free library, generous free tier, full skill tree. |
| Thenics / Thenx | Deep progressions, "Thenics Coach." ~$14.99/mo or $99.99/yr. Strong brand. |
| The Movement Athlete | Strongest for gymnastics skills (handstand, planche, human flag). Also injury rebuild. |
| Berg Movement | Skills-first: muscle-ups, front levers, planches. |
| Calisthenix Pro | Planche and front lever focus. |
| Madbarz | HIIT-style bodyweight, outdoor/bar park training. |
| Fitloop, Hybrid Calisthenics | Genuinely usable free tiers. |
| EVO Routines | Personalized, adapts to level. |
| Caliverse | Large movement catalogue; a "training menu" more than a program. |

**TODO:** download Calistree and Calistack, assess how gamified their trees actually are vs TenXRep's.

### The defensible ground

> **Skill tree + per-muscle volume history + imbalance diagnosis, in one app.**

Muscle & Motion teaches anatomy; it doesn't know your history. Calistree and Calistack give you a *curriculum* — do this, then this — but can't tell you **why you're stuck**.

TenXRep can say: *"your front lever has stalled because your posterior chain volume is half your anterior."*

That's a **diagnosis, not a curriculum**. Narrower ground, but nobody's standing on it.

**Answered (2026-09-26): no, it doesn't.** Zero references to balance or volume-history data across every skill component (`CategoryColumn`, `RadialSkillTree`, `SkillDetailPanel`, `SkillTreeView`, `SkillTree.tsx`), and no readiness or weak-link code in the API. So the defensible ground above is currently a *claim about two separate features*, not something the app actually does. Building that link is the readiness score (§7.1) — tracked in BACKLOG.md.

---

## 3. Positioning

**Reposition, don't rebuild. Same app, different front door.**

- Lead with **calisthenics**. The 3D proves the promise rather than being the promise.
- Shift from "see your muscles in 3D" (sounds like an anatomy app, and Muscle & Motion owns that at 1,200 exercises deep) to naming the outcome: *"know exactly why your muscle-up isn't happening yet."*
- Narrow hard enough that a calisthenics athlete lands and thinks "this is for me specifically" — even if most general lifters bounce. **Half-narrowing doesn't work.**
- Retention story: anatomy is a one-look novelty. A volume heat map and a skill tree both get *better* the longer you use them.

### On the logger

Never going to out-log Strong or Hevy — and shouldn't try. **The logger isn't the product, it's the sensor.** No logging means no volume data, which means no imbalance analysis and no skill-tree progress.

Keep the scope. Make it fast and boring.

---

## 4. Homepage rewrite

### Biggest issue: the paywall, not the copy

The skill tree, Balance View, Volume View, and corrective micro-programs are **all Pro-only**. A free user gets a workout logger with a basic 3D model — which is exactly the product Strong and Hevy already do better.

This likely explains a chunk of the day-one drop-off: **people who download for free never see what makes TenXRep different.**

- [ ] Move part of the skill tree into Free — one or two complete skills, or the first few progressions of every skill
- [ ] Keep the *diagnosis* layer paid: imbalance analysis, readiness score, corrective programs
- [ ] Rationale: get people hooked on the tree, then charge for the answer to "why am I stuck?"

### Hero

Current: *"See Your Muscles in 3D — the only fitness app that shows you exactly which muscles you're training in real-time 3D."*

Problems: leads with technology, and the "only" claim is contestable (Muscle & Motion, Muscle Map AI). "Only" claims invite someone to prove you wrong.

Headline candidates:

- "Know exactly why your handstand isn't happening yet."
- "The calisthenics tracker that shows you what's holding you back."
- "Stop guessing why you've stalled. See it."

Subheadline moves the 3D to proof:

> "TenXRep maps every rep to your muscles in 3D, so you can see the weak link between you and your next skill."

### Page order is upside down

Current order leads with the 206-exercise library — the weakest differentiator (Muscle & Motion has 1,200+). Skill tree is second, imbalance detection fourth.

Proposed order:

1. Skill tree
2. Imbalance detection, framed as **"why you're stuck"**
3. Volume + overtraining
4. Workout recommendations
5. Exercise library (last, or cut)

Same fix in the problem section: *"Tracking calisthenics progressions is a mess"* is the best pain point and it's third. The spreadsheets / notes app / no clear path from tuck planche to full planche line is strong copy. **Lead with it.**

### "Built for Athletes" section undoes the narrowing

Equal cards for calisthenics athletes and gym-goers tells visitors it's for everyone.

- [ ] Make the page fully calisthenics-first
- [ ] Handle lifters with one line: *"Lift weights too? TenXRep tracks everything."* — not turned away, not the headline

### Copy inconsistencies (quietly hurt credibility)

- [ ] Exercise count: **206+** in features vs **160+** in free tier — both wrong, the DB has **251**
- [ ] Skill count: **14** in features vs **15** in pricing — **15** is correct (91 progressions, not 88 as the monorepo CLAUDE.md says)
- [ ] Brand written **"TenxRep"** in the workout-recommendations section, **"TenXRep"** everywhere else
- [ ] FAQ "Is TenXRep available now?" makes the product sound unfinished — drop it

### Keep — these are working

- Warm-for-push / cool-for-pull color system. Genuinely clear idea.
- *"Treats bodyweight skills as first-class citizens, not an afterthought"* — best line on the page. Give it a more prominent spot.
- $4.99/mo is an easy yes **if** the free tier does its job first.

---

## 5. Sequenced plan

Each step's output feeds the next. Resist doing them in parallel.

### Step 0 — Finish the user interviews *(in progress)*

Keep hand-emailing every existing user. Looking specifically for:

- Where exactly they dropped off
- Whether logging friction was the cause
- Whether anyone mentions calisthenics or the skill tree **unprompted**

**Don't move past this blind.** If the interviews contradict the calisthenics bet, better to know before rebuilding the messaging.

### Step 1 — Fix the logging friction

Cheapest high-impact fix, independent of the positioning question. See §6.

### Step 2 — Reposition

Homepage, App Store listing, and the framing of short-form videos. See §4.

### Step 3 — Ship the skill readiness score

First genuinely new feature, strongest retention lever. See §7.

### Step 4 — Go where the audience already is

Calisthenics subreddits, creators, parks. See §8 and §9.

### Later, not now

Prescriptive linking, weak-link detection, video capture against skill nodes, adaptive programs. All good ideas. None of them fix a day-one drop-off, so they wait.

### On building something new in parallel

TenXRep isn't finished — it's mid-diagnosis with an untested repositioning bet. A second product now is the most seductive form of avoidance, and parallel usually means neither gets the focus it needs. The next stretch is the most intense part. A reposition is effectively a new launch; the freshness is available *inside* this work.

---

## 6. Logging UX

**Reported problem:** up/down stepper toggles for sets, weight and reps feel clunky on native iOS. Steppers get painful fast going from 20 → 60 lbs.

**On sliders:** probably not the answer. Fiddly with sweaty hands, hard to land on an exact number.

### What Strong and Hevy do

- **Prefill from history.** Previous weight and reps auto-filled as the starting point. Single biggest win.
- **Tap-count is the metric.** Reviewers literally count clicks to log a heavy triple — every extra tap is a second wasted at 160 bpm.
- **Strong's screen shows three things:** exercise name, previous performance, input fields. Nothing else.
- **Hevy:** quick single-set input, easy duplicate sets, templates, exercise favorites.
- Both: warmup / drop set / failure / superset markers, optional RPE-RIR per set.

### Fixes

- [x] ~~Prefill last session's weight and reps by default~~ — **already shipped.** `buildPrefillFromLastSession` carries `weightPerSet`, `repsPerSet`, `sets` and `is_weighted` from the last logged session of the same exercise (`useAddToTodayWorkout.ts`, `Index.tsx:601`). So the single biggest win here is done, and the remaining problem is narrower than this section implies.
- [ ] ~~Replace steppers with tap-the-number → keypad, plus preset chips~~ — **superseded (2026-09-25).** Decided the other way: keep steppers, **remove the text input from reps and sets entirely**, and keep tap-to-type **only as the weight fallback** — so the common path never opens the keyboard at all. The real defect isn't steppers, it's that weight steps by **±0.5 lb** (270 taps to reach 135) while 338 of 416 logged weights are multiples of 5. See the phase-1 item in BACKLOG.md for the full spec, including duration increments for timed exercises and the "+ Add weight" collapse.
- [ ] Add duplicate / repeat-previous-set button
- [ ] Strip the logging screen to essentials: exercise, previous performance, inputs
- [ ] Add **skill attempt logging** — holds, negatives, failed reps (feeds the tree and readiness score)

**Target: one or two taps to log a set, not five.**

---

## 7. Feature ideas

Roughly ordered by value-to-effort.

### 7.1 Skill readiness score — build first

Turn logged volume into a percentage toward each skill: *"you're 60% ready for a muscle-up."*

**Most of the work already exists.** The skill tree already has prerequisite progressions with concrete thresholds (e.g. "5 sets of 10 pull-ups before attempting a muscle-up"). The readiness score is **surfacing that existing checklist as a single number**. Three of five prerequisites cleared and halfway through the fourth ≈ 70%.

Same data, much better feeling. A checklist reads as "not done yet"; a percentage reads as progress.

**Why it's the strongest retention lever:** calisthenics skills take months. People feel like they're getting nowhere between milestones. A number that ticks up weekly gives visible progress on days the skill itself hasn't moved — and a reason to open the app daily.

#### The "prerequisites met but still can't do it" problem

Design for this explicitly. Every other app's answer is "keep trying." This is where the imbalance data earns its keep.

When all prerequisites are cleared but the skill still isn't happening, the app says: *strength likely isn't the limiter — it's technique or a specific weak link.* Then offer:

- The **3D weak-link view** — which chain is probably giving out
- A **technique checklist** for that specific skill

Turns the most demoralizing moment in calisthenics into the app's best moment.

### 7.2 Prescriptive linking

The app currently *diagnoses* imbalance. Next step is acting on it: front lever stalled + posterior volume thin → *"here are three accessories, do them Thursday."*

Nobody in the calisthenics space does this, because nobody else has both halves of the data.

### 7.3 Weak-link detection from failed reps

Log a failed muscle-up attempt → 3D layer shows which chain probably gave out. Turns failure into information.

### 7.4 Progressive photo/video capture tied to skill nodes

Calisthenics people already film every attempt obsessively. Let the app hold that history against the skill tree so visual progress lives alongside the data.

### 7.5 Adaptive programs — later, not now

The "12 weeks to a muscle-up" space is owned deeply by Thenics and The Movement Athlete. Entering with a static plan is a losing move.

The version only TenXRep could build is **adaptive**: a fixed program says "week three, five sets of negatives" regardless of what you've done. TenXRep could say *"you've under-hit pulling volume this week, so we're adjusting."* The program reshapes around reality — only possible because the volume data is already there.

**But not yet.** Big build, and the current bottleneck is day-one drop-off. If people stick, this becomes the obvious paid upgrade.

---

## 8. Content strategy

### The burnout problem

Chasing one long-term skill (30-second freestanding handstand) means posting what feels like the same clip repeatedly — 5 seconds, then 10, still falling short. Exhausting to make, repetitive to watch. Posting has stopped.

### The reframe

**The repetition isn't the problem — the framing is. Don't post the attempt. Post the diagnosis.**

Instead of *"still trying for 30 seconds, fell short again,"* open the app on camera: *"my shoulders are getting plenty of volume, but my core work is way down — that's why I'm wobbling at 10 seconds."*

The video is about the **finding**, not the hold. Failure becomes evidence rather than the subject. A demo disguised as a vlog — and **progress isn't required to post**, which is exactly what made the old format unsustainable.

### Formats to try

- **Diagnosis videos** — explain a stall using the data, app on camera
- **Myth-busting** — "you're not doing a pull-up wrong, your lats aren't firing," with the 3D showing it
- **Analyze a stranger's stuck skill** from the comments — turns the feed into a service, endlessly renewable

### Platform split

Don't cross-post the same clip everywhere.

| Platform | Strategy |
|---|---|
| **TikTok** | Pure skill content, no age framing. Young audience. Hooks, diagnoses, myth-busting. Volume plays here. |
| **YouTube** (Shorts + long) | Age angle works. *"Training for a handstand at 43 — here's what my data says about my recovery."* Audience sits with nuance. |
| **Instagram** | Currently mostly personal network. **Start a separate TenXRep account** so the audience is built, not inherited. |

### On the age angle (43, training around slower recovery)

Including age seemed to reduce views/likes. Two possible causes, worth separating:

1. **Audience composition** — TikTok skews young; twenty-somethings don't care about recovery at 40. Likely the main factor.
2. **Framing** — *"43 and still trying"* reads as an apology. *"Here's what actually works after 40"* reads as authority. Same fact, opposite energy.

The angle is genuinely underserved: most calisthenics content is twenty-something guys doing planches, and almost nobody speaks to adults training around slower recovery. It turns slower progress from something to apologize for into the reason to listen.

### Important: filter the feedback source

Family and friends saying "the app isn't for me" are **not market feedback** — they're non-lifters being polite. Discount accordingly.

---

## 9. Distribution

### Communities

- **Calisthenics subreddits** — not with a launch post (ignored or removed). Answer "why can't I get my muscle-up" questions with genuine analysis; mention the app only when actually relevant. Slower, but it works.
- **Mid-size calisthenics creators** — they'd plausibly want a tool that visualizes *why* a follower is stuck. Framed right, that's content for them, not promotion for TenXRep.

### Personal trainers

Interesting less as customers than as a **channel** — one trainer demoing the 3D to thirty clients a week is thirty in-context impressions. But no existing trainer relationships, so this is a later play.

### Local scene (San Jose / Bay Area)

Currently the only person in the immediate network doing calisthenics. Community has to be found, not converted.

**Groups:**

- **San Jose Calisthenics Group** — Facebook (facebook.com/groups/teamrancho)
- **Bay Area Bars Calisthenics (BABC)** — South SF. Weekly classes, 1-on-1, open gym, events. ~2,600 IG followers (@bayareabarscalisthenics). Started as a group meeting at Progress Park in SF. **Has an organizer and a real community — reach out directly. Best single contact.**

**Parks with bars:**

- Backesto Park, San Jose — outdoor pull-up bars
- Cataldi Park, San Jose — exercise station
- Campbell Outdoor Exercise Park & Community Track — 12 stations, all levels, likely to have people around
- Bowers Park, Santa Clara — quiet; fine for training, poor for meeting people

**Resource:** calisthenics-parks.com — community-mapped database of 27,000+ spots worldwide.

**Why parks beat gyms:** people train in groups, everyone watches everyone, there's usually someone grinding the same skill for months. No cold-approach awkwardness — just turn up and train.

### On cold approaching

It's unnerving, so don't. Lower-pressure options:

- Wear a TenXRep shirt at the gym. The QR rarely gets scanned, but the shirt **earns questions** — it flips who approaches whom.
- Just train at the 24-hour gym for a few weeks and let conversations happen. Trainers are chatty between clients.

**Even if nobody downloads, these conversations are valuable** — hearing how calisthenics people describe being stuck, in their own words, is the homepage copy writing itself.

---

## 10. Open questions

- [x] ~~Does the app currently link skill-tree progress to imbalance data?~~ **No** — verified 2026-09-26, see §2.
- [ ] How gamified are Calistree's and Calistack's trees compared to TenXRep's? (download both)
- [ ] What do the user interviews actually say — does anyone mention calisthenics unprompted?
- [ ] Which free-tier features specifically to unlock, and what does that do to trial conversion?
