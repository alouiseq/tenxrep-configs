---
name: social-content
description: Generate TikTok and YouTube Shorts content (caption, title, description, hashtags) for an exercise video
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

## Output Format

Produce content for TikTok and YouTube Shorts using these templates:

### TikTok

**On-screen hook text:** `Muscles you didn't know the [exercise] hits`

**Caption:**
```
Muscles you didn't know the [exercise] hits #gymtok #calisthenics #muscleactivation #bodyweighttraining #[exercise-hashtag]
```

Rules:
- Keep caption under ~80 characters before hashtags (TikTok truncates after that)
- 3-5 hashtags: mix broad (#gymtok, #calisthenics, #fitness) with niche (#muscleactivation, #bodyweighttraining) and exercise-specific
- The exercise-specific hashtag should be the exercise name as one word, lowercase, no spaces (e.g., #frogstand, #lsit, #elbowlever)

### YouTube Shorts

**Title:** `Every Muscle [a/an] [Exercise] Actually Targets`

Rules:
- Write like a search query
- Keep under 70 characters
- No clickbait punctuation (!!)

**Description:**
```
Every muscle activated during [a/an] [exercise] [on parallettes/at the bar/etc if applicable] -- front and back view.

#[exercise-hashtag] #calisthenics #muscleactivation #bodyweighttraining #fitness
```

Rules:
- 1-2 short lines expanding on the title
- 3-5 hashtags at the end
- Do NOT include #Shorts (YouTube detects it automatically)
- First 3 hashtags auto-appear above the title as clickable links

## Guidelines
- Reference docs/marketing/SHORT_FORM_VIDEO_BLUEPRINT.md for the full strategy
- Keep the same hook template ("Muscles you didn't know X hits") for brand consistency
- Use "a" or "an" appropriately before the exercise name
- If the exercise uses equipment (parallettes, bar, rings), mention it in the YT description
- Output ONLY the formatted content -- no extra commentary unless the user asks
