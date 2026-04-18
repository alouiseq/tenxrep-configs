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

2. **Full activation** — `Every muscle the [exercise] hits`
   - Clean, search-friendly, honest. Safe default for textbook exercises.

3. **Ranked breakdown** — `Every muscle the [exercise] hits, ranked`
   - Visual breakdown angle. No surprise promise.

### Note on the "unc" (40+) angle

The creator is 40+ ("unc"). Analytics showed that unc-angle hooks ("40 year old attempts X") underperformed on TikTok compared to "didn't know" hooks (274-351 views vs 453-763 views). However, the unc angle performed well on YouTube (1,230 views for tuck push-up).

**Current strategy:** Keep the unc identity in the bio/profile/brand and comment replies, NOT in the on-screen hook. The "didn't know" hook is the primary hook across all platforms to keep things simple (KISS). The unc persona differentiates the creator, but the muscle activation curiosity gap is what makes people watch.

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
- **Add location** when posting — helps with local discovery, especially for new accounts
- **AI Label**: leave off unless the video is primarily AI-generated. The 3D muscle overlay is a visual effect, not AI-generated content

## Posting Schedule

### Weekly cadence (3 videos/week across 3 platforms)

The creator can't post daily. The goal is consistency over volume — 3 new videos per week, posted to all 3 platforms on the same day at each platform's optimal time.

**Recommended weekly rhythm:**

| Day | TikTok (7 AM) | Instagram Reels (7 PM) | YouTube Shorts (7 PM) |
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
