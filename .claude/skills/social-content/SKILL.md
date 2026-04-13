---
name: social-content
description: Generate TikTok, YouTube Shorts, and Instagram Reels content (caption, title, description, hashtags) for an exercise video. Use whenever the user mentions creating social content, uploading a video, or producing a clip for a TenXRep exercise — even if they don't explicitly say "social content" or "caption".
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

## Step 1: Get the actual target muscle list

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

### Surprising exercises → "didn't know" hook

**On-screen hook text:** `Muscles you didn't know the [exercise] hits`

Use this ONLY when there's a genuinely non-obvious muscle in the target list. The video/caption should highlight that specific muscle — otherwise the viewer feels baited.

### Textbook exercises → pick one of these alternatives

Rotate through these so the feed doesn't feel repetitive. Pick whichever fits the exercise best, or offer the user 2-3 options to choose from.

1. **Ranked breakdown** — `Every muscle the [exercise] hits, ranked`
   - Honest, no surprise promise, just a clean visual breakdown.

2. **Harder than it looks** — `Why the [exercise] is harder than it looks`
   - Frames effort and difficulty instead of novelty.

3. **Killer move** — `The [exercise] is a [primary muscle] killer`
   - Leans into the obvious instead of fighting it. Good for single-dominant-muscle moves.

4. **POV / pain angle** — `POV: your [muscle] after 10 seconds of [exercise]`
   - Relatable effort angle. Works well for isometric holds.

5. **Full activation** — `Full muscle activation on the [exercise]`
   - Clinical, search-query friendly. Good default.

### "Unc" angle hooks — age-defying persona

The creator is 40+ ("unc"). These hooks lean into the age angle to create a scroll-stopping expectation gap. Use these to break up the muscle-activation hooks and build the personal brand. Mix them in roughly 1 in 3 videos — don't make every video about age, but keep it as a recurring flavor.

Pick whichever fits the exercise and context:

1. **Age challenge** — `40 year old attempts [exercise]`
   - Works for harder/impressive moves. Sets low expectations, then delivers.

2. **Defying doubt** — `They said start calisthenics in your 20s`
   - Doesn't even need to name the exercise — the visual does the work. Great for advanced moves (planche, handstand, levers).

3. **Unc flex** — `Things unc can do that you can't`
   - Playful, confident, slightly confrontational. Good engagement bait.

4. **Still got it** — `40+ and still hitting the [exercise]`
   - Straightforward, inspirational tone. Good for moves that look impressive.

5. **Age + activation combo** — `Unc's muscle activation on the [exercise]`
   - Bridges the personal brand with the product. Shows the 3D visualization while nodding to the age angle.

When using unc hooks, the TikTok hashtags should include #over40fitness or #fitover40 in addition to the regular calisthenics tags. These tap into the underserved 30-50 demographic that's actively looking for this content.

## Step 4: Produce the content

Once you've picked the hook, generate TikTok, YouTube Shorts, and Instagram Reels content using these templates.

### TikTok

**On-screen hook text:** the hook you picked in Step 3

**Caption:**
```
[Hook text] #gymtok #calisthenicsworkout #muscleactivation #bodyweighttraining #[exercise-hashtag]
```

Rules:
- Keep caption under ~80 characters before hashtags (TikTok truncates after that)
- 3-5 hashtags: mix broad (#gymtok, #calisthenicsworkout, #fitness) with niche (#muscleactivation, #bodyweighttraining) and exercise-specific
- The exercise-specific hashtag should be the exercise name as one word, lowercase, no spaces (e.g., #frogstand, #lsit, #elbowlever)

### YouTube Shorts

**Title:** a search-query-friendly rephrasing of the hook

Examples:
- Surprising hook → `Every Muscle [a/an] [Exercise] Actually Targets`
- Ranked → `[Exercise] Muscle Activation, Ranked`
- Harder than it looks → `Why the [Exercise] Is Harder Than It Looks`
- Full activation → `Every Muscle the [Exercise] Works`

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

#calisthenics #muscleactivation #bodyweighttraining #[exercise-hashtag] #fitness
```

Rules:
- Caption can be longer than TikTok — up to ~150 characters before hashtags is fine
- 5-8 hashtags in the caption: mix broad (#calisthenics, #fitness, #workout) with niche (#muscleactivation, #bodyweighttraining) and exercise-specific
- Additionally, post 5-10 more hashtags as the **first comment** for extra discovery. These should be broader/adjacent: #homeworkout, #fitnessmotivation, #strengthtraining, #coreworkout, #gymnast, etc. Pick ones relevant to the exercise.
- Do NOT use #reels or #reelsinstagram (Instagram detects format automatically, and these tags are oversaturated/useless)
- The exercise-specific hashtag uses the same format as TikTok (one word, lowercase, no spaces)
- No TikTok-specific hashtags (#gymtok, #fyp) — these mark you as a cross-poster and can hurt reach

**First comment hashtags example:**
```
#homeworkout #coreworkout #fitnessmotivation #strengthtraining #gymnast #workoutinspo #fitnessjourney
```

## Posting Schedule

### Weekly cadence (3 videos/week across 3 platforms)

The creator can't post daily. The goal is consistency over volume — 3 new videos per week, posted to all 3 platforms on the same day at each platform's optimal time.

**Recommended weekly rhythm:**

| Day | TikTok (7 AM) | Instagram Reels (7 AM) | YouTube Shorts (12 PM) |
|-----|---------------|------------------------|------------------------|
| **Monday** | Video #1 | Video #1 | Video #1 |
| **Wednesday** | Video #2 | Video #2 | Video #2 |
| **Friday** | Video #3 | Video #3 | Video #3 |

- **Monday** is the proven best TikTok day based on analytics (frog stand: 730 views)
- **Mon/Wed/Fri** are all strong weekdays across all platforms — weekend posts have consistently underperformed
- Each platform's algorithm is independent — posting to all 3 the same day doesn't hurt any of them
- Simple to remember: Mon/Wed/Fri, all three platforms, done

This schedule is a starting point. Adjust based on what your analytics show after 3-4 weeks.

### Peak times reference
- **TikTok**: Tue–Thu 7–9 AM, Fri 11 AM–1 PM, fitness content also does well at 5–7 AM
- **Instagram Reels**: Mon–Fri 6–9 AM, Tue/Wed 10 AM–1 PM, Sun 7–9 PM
- **YouTube Shorts**: Fri–Sat 9–11 AM, weekdays 12–3 PM

All times are local to your audience's timezone. Once you have 15-20+ posts, check each platform's native analytics for when *your specific* audience is most active and adjust accordingly.

## Guidelines
- Reference `docs/marketing/SHORT_FORM_VIDEO_BLUEPRINT.md` for the full strategy
- Use "a" or "an" appropriately before the exercise name
- Output ONLY the formatted content — no extra commentary unless the user asks
- If you're unsure whether an exercise is surprising or textbook, ask the user rather than guessing
- When cross-posting the same video: remove any TikTok watermark before uploading to Reels/Shorts, and never use platform-specific hashtags on the wrong platform (#gymtok on Instagram, #fyp on YouTube, etc.)
