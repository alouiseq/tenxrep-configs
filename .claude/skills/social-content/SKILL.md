---
name: social-content
description: Generate TikTok and YouTube Shorts content (caption, title, description, hashtags) for an exercise video. Use whenever the user mentions creating social content, uploading a video, or producing a clip for a TenXRep exercise — even if they don't explicitly say "social content" or "caption".
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

## Step 4: Produce the content

Once you've picked the hook, generate both TikTok and YouTube Shorts content using these templates.

### TikTok

**On-screen hook text:** the hook you picked in Step 3

**Caption:**
```
[Hook text] #gymtok #calisthenics #muscleactivation #bodyweighttraining #[exercise-hashtag]
```

Rules:
- Keep caption under ~80 characters before hashtags (TikTok truncates after that)
- 3-5 hashtags: mix broad (#gymtok, #calisthenics, #fitness) with niche (#muscleactivation, #bodyweighttraining) and exercise-specific
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

## Guidelines
- Reference `docs/marketing/SHORT_FORM_VIDEO_BLUEPRINT.md` for the full strategy
- Use "a" or "an" appropriately before the exercise name
- Output ONLY the formatted content — no extra commentary unless the user asks
- If you're unsure whether an exercise is surprising or textbook, ask the user rather than guessing
