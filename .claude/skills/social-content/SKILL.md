---
name: social-content
description: Generate TikTok, YouTube Shorts, and Instagram Reels content (caption, title, description, hashtags) for an exercise video or a calisthenics progression/journey video. Use whenever the user mentions creating social content, uploading a video, or producing a clip for a TenXRep exercise or a calisthenics skill they're progressing on — even if they don't explicitly say "social content" or "caption".
user_invocable: true
arguments:
  - name: exercise
    description: The exercise name (e.g., "L-sit", "Frog Stand", "Elbow Lever")
    required: true
---

# Social Content Generator

Generate social media content for a TenXRep exercise video upload. Follow the SHORT_FORM_VIDEO_BLUEPRINT.md conventions exactly.

## Input
The user provides an exercise name as the argument: `$ARGUMENTS`

## Step 1: Identify the content type

There are two content tracks. Pick before going further:

- **Activation video** — showing the muscles a single exercise hits, with the 3D overlay. Default for most YouTube uploads. Continue to Step 1a.
- **Progression journey video** — filming attempts of a calisthenics skill the creator is working toward (planche, muscle-up, front lever, handstand, etc.). The angle is the journey, not muscle activation. Skip Step 1a and jump to Step 3's "Calisthenics progression" hook family.

If it's not obvious from the argument or context, ask: "Is this an activation video or a progression journey video?" Skill names like "Planche", "Muscle-up", "Front lever", "Handstand" usually imply progression. Exercise names like "Frog stand", "L-sit", "Push-up" usually imply activation, but can be either.

## Step 1a: Get the actual target muscle list (activation videos only)

Before drafting anything, find out which muscles the TenXRep app actually shows as targets for this exercise. The hook depends on this — never guess or invent muscles.

Two ways to get the list:
1. **Ask the user** — "Which muscles does the app show as targets for [exercise]? (or paste a screenshot)" This is the fastest path.
2. **Check the exercise data** — if the user wants you to look it up, the source of truth is the exercise library in `tenxrep-api` (search the seed/exercise data files for the exercise name).

Do not proceed to Step 2 until you have the confirmed muscle list.

## Step 2: Classify the exercise as "surprising" or "textbook"

Look at the target muscle list and decide which bucket the exercise falls into. This decides which hook template to use.

**Textbook** — the target list only contains muscles that any fitness-literate viewer would already guess. If you told a gym-goer "name the muscles the [exercise] hits" and they'd name all of them, it's textbook.

Examples of textbook exercises:
- L-sit → upper abs, lower abs, hip flexors, quads (all obvious)
- Plank → abs, core
- Bicep curl → biceps
- Standard squat → quads, glutes

**Surprising** — the target list contains at least one muscle most people wouldn't guess. The non-obvious muscle becomes the anchor of the hook.

Examples of surprising exercises:
- Push-up → includes serratus anterior (surprising)
- Frog stand → includes upper back / shoulder stabilizers (surprising)
- Deadlift → includes lats and forearms heavily (surprising)
- Dips → includes lower chest + serratus (surprising)

If you're not sure, ask the user: "Does the app show any muscles here that would surprise a typical gym-goer? If everything on this list is obvious, I'll use the textbook hook template."

**Never** force the "didn't know" hook onto a textbook exercise. A hook that overpromises gets comments like "is that not obvious?" which undercuts the brand.

## Step 3: Pick a hook template based on the classification

### Surprising exercises → "didn't know" hook family (primary — use by default)

This is the proven best-performing hook based on analytics (frog stand: 763 views, 8.5% like rate on TikTok). Use as the default whenever there's a genuinely non-obvious muscle in the target list. One hook, same content across all three platforms — keep it simple.

Rotate through these variants to avoid hook fatigue. They all deliver the same "your assumptions are wrong" curiosity gap, just with different wording:

1. `Muscles you didn't know the [exercise] hits`
2. `The [exercise] targets more muscles than you think`
3. `You won't believe what muscles the [exercise] works`
4. `The [exercise] hits muscles you'd never guess`
5. `What the [exercise] actually targets`

Pick whichever hasn't been used recently. Don't repeat the same variant back-to-back.

### Textbook exercises → alternative hooks

Use these ONLY when the target muscles are all obvious and the "didn't know" hook would misfire (e.g., L-sit got "is that not obvious?" comment). Pick whichever fits best:

1. **Harder than it looks** — `Why the [exercise] is harder than it looks`
   - Best for isometric holds and exercises that look deceptively simple.

2. **Comparison/vs** — `[Exercise] harder than [common exercise]?`
   - Compares an advanced variation to the common version (e.g., "Lean push-ups harder than regular push-ups?"). Creates instant curiosity for anyone who does the common version. Works well for progressions.

3. **Full activation** — `Every muscle the [exercise] hits`
   - Clean, search-friendly, honest. Safe default for textbook exercises.

4. **Ranked breakdown** — `Every muscle the [exercise] hits, ranked`
   - Visual breakdown angle. No surprise promise.

### Calisthenics progression videos → journey hook family

For progression/skill journey content (planche, muscle-up, front lever, handstand, human flag, one-arm pull-up, etc.) where the angle is the journey of mastering the move, not muscle activation. The "exercise" argument is the skill name (e.g., "Planche", "Muscle-up").

These hooks are tuned to keep working when the rep itself doesn't look dramatically different week-to-week — they lean on context (day count, cue, failure point, time delta) rather than the visual alone. Pick whichever fits the footage:

1. **Attempt count** — `Day [N] attempting the [skill]`
   - Best when there's a clear day count or attempt streak. Anchors the journey timeline and invites follow-back ("I want to see day 60").
   - Examples: `Day 47 attempting the planche`, `Day 12 of trying the muscle-up`, `Month 3 chasing the front lever`

2. **Breakthrough / cue** — `The cue that finally made the [skill] click`
   - Use when a specific cue, tweak, or correction unlocked progress. Promises a takeaway, which performs well even on a plateau day.
   - Examples: `The cue that finally made the planche click`, `What unlocked my muscle-up`, `The fix that saved my handstand`

3. **Plateau / failure point** — `Why my [skill] keeps collapsing here`
   - Use when there's visible failure footage. Honest "stuck" content — pairs well with form analysis or a slow-mo of the breakdown moment. Counter-intuitively performs well because it's relatable.
   - Examples: `Why my planche keeps collapsing here`, `Where my front lever falls apart`, `The exact frame my muscle-up fails`

4. **Then vs now** — `[Skill]: month [X] vs month [Y]`
   - Best for side-by-side or split-screen comparison footage. Pure payoff content — only post when the delta is actually visible.
   - Examples: `Planche: month 1 vs month 6`, `Muscle-up progression in 90 days`, `My handstand then vs now`

**When to pick which:**
- Got a visible win this week → **then vs now** or **breakthrough**
- Plateau / no visible progress → **plateau** (with failure footage) or **attempt count** (anchors timeline regardless)
- New cue or coaching insight → **breakthrough**
- First post in a series → **attempt count** (sets up the journey arc)

**Platform priority:** Progression content thrives on TikTok and Instagram (struggle → payoff arc beats algorithmic feeds). YouTube optional — if posting there too, use the **attempt count** or **then vs now** variant as the title since they're search-friendly. Skip YouTube on plateau/failure posts; they don't search well.

**Skip Step 1a (muscle list)** for progression content — the hook is about the journey, not muscle activation.

**Visual overlay — use the TenXRep skill tree, not the 3D muscle overlay.** The skill tree is the better visual for progression videos because it (a) shows the viewer exactly where the creator is in the progression (e.g., step 2 of 4 in the Dips path), (b) gives them a roadmap to care about, and (c) quietly differentiates the brand — no other calisthenics creator has a skill tree visualization. The 3D muscle overlay is for activation videos; skip it here.

Two skill-tree views are available in the app, used for different moments in the cut:

- **Tree node view** (compact vertical chain, e.g., "Dips — 4 skills | 25%" with orange/gray nodes) — **default overlay**. Glanceable in under a second. Use as:
  - Corner inset during the rep
  - 1-second intro card
  - Both panels of a then-vs-now split-screen (the color delta tells the story)
  - Plateau and attempt-count posts (the unchanged orange node *is* the message)

- **Detail sheet view** (mobile bottom-sheet with title, stars, level, full progression path, rep/set targets, "Mastered!" badge, PR, date) — **the receipt**. Too text-dense to read during motion, but exactly what you want when you need credibility. Use as:
  - Outro card on a "I just hit it" / breakthrough post (hold for ~2 seconds: green bar, PR, date)
  - First-post-in-series setup ("here's what I'm chasing — 5 reps × 5 sets of Impossible Dip")

**Default rule:** tree node view for the rep itself, detail sheet for outro/receipt moments.

### Note on the "unc" (40+) angle

The creator is 40+ ("unc"). Analytics showed that unc-angle hooks ("40 year old attempts X") underperformed on TikTok compared to "didn't know" hooks (274-351 views vs 453-763 views). However, the unc angle performed well on YouTube (1,230 views for tuck push-up).

**Current strategy:** Keep the unc identity in the bio/profile/brand and comment replies, NOT in the on-screen hook. The "didn't know" hook is the primary hook across all platforms to keep things simple (KISS). The unc persona differentiates the creator, but the muscle activation curiosity gap is what makes people watch.

## Step 4: Produce the content

Once you've picked the hook, generate TikTok, YouTube Shorts, and Instagram Reels content using these templates.

**On-screen hook text (all platforms):** the hook you picked in Step 3. The same on-screen text is burned into the video and used across TikTok, YouTube Shorts, and Instagram Reels — list it once at the top of the output, not inside any single platform section.

### TikTok

**Caption:**
```
[Hook text] #gymtok #calisthenicsworkout #muscleactivation #bodyweighttraining #[exercise-hashtag]
```

Rules:
- Keep caption under ~80 characters before hashtags (TikTok truncates after that)
- 3-5 hashtags: mix broad (#gymtok, #calisthenicsworkout, #fitness) with niche (#muscleactivation, #bodyweighttraining) and exercise-specific
- The exercise-specific hashtag should be the exercise name as one word, lowercase, no spaces (e.g., #frogstand, #lsit, #elbowlever)
- **For progression videos:** swap `#muscleactivation` for `#calisthenicsprogression` (or `#[skill]progression` like `#plancheprogression`, `#muscleupprogression`). Keep `#calisthenicsworkout` and the skill-specific hashtag.

### YouTube Shorts

**Title:** a search-query-friendly rephrasing of the hook

Examples:
- Surprising hook → `Every Muscle [a/an] [Exercise] Actually Targets`
- Ranked → `[Exercise] Muscle Activation, Ranked`
- Harder than it looks → `Why the [Exercise] Is Harder Than It Looks`
- Full activation → `Every Muscle the [Exercise] Works`
- Progression (attempt count) → `Day [N] Attempting the [Skill]`
- Progression (then vs now) → `[Skill] Progression: [X] Months`

Rules:
- Write like a search query
- Keep under 70 characters
- No clickbait punctuation (!!)

**Description:**
```
[1-2 short lines expanding on the title, mentioning equipment if relevant]

#[exercise-hashtag] #calisthenics #muscleactivation #bodyweighttraining #fitness
```

Rules:
- 1-2 short lines expanding on the title
- 3-5 hashtags at the end
- Do NOT include #Shorts (YouTube detects it automatically)
- First 3 hashtags auto-appear above the title as clickable links
- If the exercise uses equipment (parallettes, bar, rings), mention it here

### Instagram Reels

**Caption:**
```
[Hook text]

[1-2 short lines expanding on the hook — slightly more descriptive than TikTok since Instagram doesn't truncate as aggressively]

#calisthenics #muscleactivation #[exercise-hashtag] #bodyweighttraining #fitness
```

Rules:
- Caption can be longer than TikTok — up to ~150 characters before hashtags is fine
- **5 hashtags max** in the caption — Instagram recommends 3-5; more can hurt reach
- Mix broad (#calisthenics, #fitness) with niche (#muscleactivation, #bodyweighttraining) and exercise-specific
- Do NOT use #reels or #reelsinstagram (Instagram detects format automatically, and these tags are oversaturated/useless)
- The exercise-specific hashtag uses the same format as TikTok (one word, lowercase, no spaces)
- No TikTok-specific hashtags (#gymtok, #fyp) — these mark you as a cross-poster and can hurt reach
- When using unc hooks, swap one broad hashtag for #over40fitness or #fitover40
- **For progression videos:** swap `#muscleactivation` for `#calisthenicsprogression` and add `#[skill]progression` (e.g., `#plancheprogression`). Keep the 5-tag cap.
- **Add location** when posting — helps with local discovery, especially for new accounts
- **AI Label**: leave off unless the video is primarily AI-generated. The 3D muscle overlay is a visual effect, not AI-generated content

## Step 5: Save progression-journey runs to the tracker

For **progression-journey videos only** (skip for activation videos), append a row to the **TenXRep Video Upload Tracker** Google Sheet under the `Progression Journeys` tab after producing the content. This keeps the Day-N series consolidated so the user can scan past entries when planning the next post.

- **Spreadsheet ID:** `1lSTepAtLe3g_c0SL6nItITDavHGK5wRce8L2Pjh4Kks`
- **Tab:** `Progression Journeys`
- **Auth:** must be `tenxrep@gmail.com`. Verify with `gws drive about get --params '{"fields": "user(emailAddress)"}'` before writing. If a different account is returned, ask the user to run `gws auth logout && gws auth login` and pick `tenxrep@gmail.com` — do not write under the wrong account.

**Columns (in order, A–O):**
1. **Skill** — the skill name (e.g., `Freestanding Handstand`)
2. **Day / Attempt** — the label used in the hook (e.g., `Day 1`, `Day 47`, `Month 3`)
3. **Filmed Date** — today's date in `M/D/YY` format (e.g., `5/2/26`)
4. **Hold Time / Metric** — leave blank; the user fills this in after reviewing the video
5. **Hook Variant** — one of: `Attempt count`, `Breakthrough / cue`, `Plateau / failure point`, `Then vs now`
6. **Notes** — short note on the post angle, overlay choices, or anything notable about the take
7. **Curated (TT/IG)?** — `Yes` (progression videos are curated by default)
8. **TikTok Date** — leave blank; user fills after posting
9. **YouTube Date** — leave blank; user fills after posting
10. **Instagram Date** — leave blank; user fills after posting
11. **On-Screen Hook** — exact hook text burned into the video
12. **TikTok Caption** — full caption with hashtags
13. **YouTube Title** — search-friendly title
14. **YouTube Description** — full description with hashtags
15. **Instagram Caption** — full caption with hashtags

**Append command** (use `valueInputOption: USER_ENTERED` so dates render correctly):

```bash
gws sheets spreadsheets values append \
  --params '{"spreadsheetId": "1lSTepAtLe3g_c0SL6nItITDavHGK5wRce8L2Pjh4Kks", "range": "Progression Journeys!A1:O1", "valueInputOption": "USER_ENTERED", "insertDataOption": "INSERT_ROWS"}' \
  --json '{"values": [[<15 column values in order>]]}'
```

After appending, confirm to the user with the sheet link and remind them which columns are blank for them to fill in later (Hold Time / Metric, TikTok / YouTube / Instagram Date).

### Logging activation videos to Exercise Tracker

For **activation videos**, ask the user if they want it logged after producing content. If yes, append to the `Exercise Tracker` tab using these 13 columns (A–M):

| # | Column | How to fill |
|---|--------|-------------|
| 1 | Exercise | Title Case (e.g., `Archer Push-Up`, `Weighted Pull-Ups`) |
| 2 | Muscle Group | Primary group (`Chest`, `Back`, `Legs`, `Deltoids`, `Core`) |
| 3 | Weight Type | `body` for bodyweight, `weighted` for added load |
| 4 | Target Muscles | Comma-separated, Title Case, matching how the app shows them |
| 5 | Curated (TT/IG)? | `Yes` if also going on TikTok/IG, `No` if YouTube only |
| 6 | TikTok Date | Today's date in `M/D/YY` if posting to TikTok, blank otherwise |
| 7 | YouTube Date | Today's date in `M/D/YY` if posting to YouTube, blank otherwise |
| 8 | Instagram Date | Today's date in `M/D/YY` if posting to Instagram, blank otherwise |
| 9 | On-Screen Hook | Exact hook text |
| 10 | TikTok Caption | Full caption with hashtags (blank if YouTube only) |
| 11 | YouTube Title | Search-friendly title |
| 12 | YouTube Description | Full description with hashtags |
| 13 | Instagram Caption | Full caption with hashtags (blank if YouTube only) |

**Date defaults:** Fill posting dates with **today's date** by default for each platform the video is going to — do not leave them blank. Detect platform-restriction hints from the input (e.g., `archer push-up (youtube only)` → fill only YouTube Date). If the user says nothing about platform restrictions, assume all three and fill all three dates with today.

**Append command:**

```bash
gws sheets spreadsheets values append \
  --params '{"spreadsheetId": "1lSTepAtLe3g_c0SL6nItITDavHGK5wRce8L2Pjh4Kks", "range": "Exercise Tracker!A1:M1", "valueInputOption": "USER_ENTERED", "insertDataOption": "INSERT_ROWS"}' \
  --json '{"values": [[<13 column values in order>]]}'
```

After appending, confirm with the sheet link and the row number it landed on.

### Logging combo / "X to Y" moves

For **combo move videos** (e.g., `Leg Raise to L-Sit`), the `Combo Moves` tab uses a slightly different 15-column schema with extra `Hook Used` and `Notes` columns. Ask the user before appending and confirm column mapping with them.

## Posting Schedule

### Weekly cadence

Film 5 videos per week. Upload all 5 to YouTube. Pick the best 3 (curated) for TikTok and Instagram.

**Recommended weekly rhythm:**

| Day | TikTok (7 AM) | Instagram Reels (7 PM) | YouTube Shorts (7 PM) |
|-----|---------------|------------------------|------------------------|
| **Monday** | Video #1 | Video #1 | Video #1 |
| **Tuesday** | — | — | Video #2 |
| **Wednesday** | Video #3 | Video #3 | Video #3 |
| **Thursday** | — | — | Video #4 |
| **Friday** | Video #5 | Video #5 | Video #5 |

- **YouTube**: Mon–Fri, 1 video/day (5/week). All exercises uploaded — builds the full reference library for the app.
- **TikTok + Instagram**: Mon/Wed/Fri only (3/week). Curated picks from the 5 — visually impressive, surprising muscles, or niche calisthenics.
- Monday is the proven best TikTok day based on analytics (frog stand: 730 views)
- Weekends off for batch-filming

This schedule is a starting point. Adjust based on what your analytics show after 3-4 weeks.

### Peak times reference
- **TikTok**: Tue–Thu 7–9 AM, Fri 11 AM–1 PM, fitness content also does well at 5–7 AM
- **Instagram Reels**: Mon–Fri 6–9 AM, Tue/Wed 10 AM–1 PM, Sun 7–9 PM
- **YouTube Shorts**: Fri–Sat 9–11 AM, weekdays 12–3 PM

All times are local to your audience's timezone. Once you have 15-20+ posts, check each platform's native analytics for when *your specific* audience is most active and adjust accordingly.

## Platform Strategy

**YouTube = full library. TikTok/Instagram = curated highlights.**

The creator has 270+ exercises in the TenXRep app. Each platform serves a different purpose:

### YouTube Shorts — upload ALL exercises
- YouTube is search-driven. Every exercise is a potential search entry point ("how to do a Bulgarian split squat").
- These videos also serve as reference links in the TenXRep exercise library, replacing third-party video links.
- YouTube doesn't punish "boring" content — low-view videos still serve their purpose as app reference material.
- Volume builds channel authority in fitness/calisthenics.

### TikTok & Instagram — curate heavily (~30-50 exercises)
Only post exercises that meet at least one of these criteria:
1. **Visually impressive** — handstands, planches, levers, muscle-ups. Scroll-stoppers.
2. **Surprising muscle activation** — exercises where the app shows non-obvious muscles (the "didn't know" hook).
3. **Uncommon/niche** — exercises most people haven't seen. Curiosity-driven.
4. **Calisthenics/bodyweight** — this is the brand. The audience follows for bodyweight skills, not dumbbell curls.
5. **Progression journey** — the creator's own attempts at a calisthenics skill (planche, muscle-up, front lever, handstand, human flag). Uses the journey hook family. This is a parallel content stream that runs alongside curated activation videos — it gives the audience a personal arc to follow rather than just standalone tips.

**Skip on TikTok/Instagram:**
- Standard gym exercises (bicep curls, lat pulldowns, bench press) — oversaturated
- Isolation exercises with obvious muscle targets — no curiosity gap
- Exercises that don't look interesting in a 15-second clip
- Anything where the 3D overlay doesn't add something the viewer couldn't already guess

At 3 videos/week on TikTok/IG, ~50 curated exercises = almost a year of content.

## Guidelines
- Reference `docs/marketing/SHORT_FORM_VIDEO_BLUEPRINT.md` for the full strategy
- Use "a" or "an" appropriately before the exercise name
- Output ONLY the formatted content — no extra commentary unless the user asks
- If you're unsure whether an exercise is surprising or textbook, ask the user rather than guessing
- When cross-posting the same video: remove any TikTok watermark before uploading to Reels/Shorts, and never use platform-specific hashtags on the wrong platform (#gymtok on Instagram, #fyp on YouTube, etc.)
