# TenXRep — User Interview Execution Plan

**Goal:** get 8–10 real replies from the ~60 registered users to decide positioning (symmetry/lagging-muscles vs. calisthenics skills) and confirm whether the empty day-one state is what's killing activation.

**Claude Code's job:** segment the user list, compute per-user personalization variables, and output a merge-ready CSV. **Not** drafting the emails — those are written below and their value depends on them not looking generated.

**Timebox:** one afternoon.

> **Schema note:** the SQL below was sketched from memory. The real schema has `workouts.completed_at` (not `performed_at`; `NULL` = planned but not logged) and `users.username` (no `name` column). `tenxrep-api/scripts/generate_outreach_csv.py` implements Steps 2–3 against the real schema and writes `outreach.csv` (gitignored — contains user emails).

---

## Step 1 — Baseline activation numbers

Run this first. It's the number that decides how urgent everything else is.

Watch for **right-censoring**: someone who signed up three days ago hasn't had a fair chance to log a second workout. Excluding them is the difference between a real number and a misleadingly bad one.

```sql
WITH eligible AS (
  SELECT id, created_at
  FROM users
  WHERE created_at < NOW() - INTERVAL '14 days'
),
ranked AS (
  SELECT w.user_id,
         w.performed_at,
         ROW_NUMBER() OVER (PARTITION BY w.user_id ORDER BY w.performed_at) AS n
  FROM workouts w
  JOIN eligible e ON e.id = w.user_id
)
SELECT
  DATE_TRUNC('month', e.created_at) AS signup_month,
  COUNT(DISTINCT e.id)        AS signups,
  COUNT(DISTINCT r1.user_id)  AS logged_1,
  COUNT(DISTINCT r2.user_id)  AS logged_2,
  COUNT(DISTINCT r5.user_id)  AS logged_5,
  ROUND(100.0 * COUNT(DISTINCT r2.user_id) / NULLIF(COUNT(DISTINCT e.id), 0), 1) AS pct_activated
FROM eligible e
LEFT JOIN ranked r1 ON r1.user_id = e.id AND r1.n = 1
LEFT JOIN ranked r2 ON r2.user_id = e.id AND r2.n = 2
  AND r2.performed_at <= e.created_at + INTERVAL '14 days'
LEFT JOIN ranked r5 ON r5.user_id = e.id AND r5.n = 5
GROUP BY 1
ORDER BY 1;
```

The `n = 2` join carries a 14-day window on purpose. "Logged a second workout eventually" and "logged a second workout in their first two weeks" are different metrics; the second predicts retention.

Also pull in the same pass:

- Median days between signup and first workout
- Histogram of workouts-per-user (`SELECT workout_count, COUNT(*) FROM (...) GROUP BY 1`)

If that histogram is a wall at 1 with almost nothing after it, the empty-state problem is confirmed before building anything.

---

## Step 2 — Segment the list

Three cohorts. Adjust column names to the real schema.

```sql
WITH activity AS (
  SELECT u.id,
         u.email,
         u.name,
         u.created_at,
         COUNT(w.id)          AS workout_count,
         MAX(w.performed_at)  AS last_workout,
         MIN(w.performed_at)  AS first_workout
  FROM users u
  LEFT JOIN workouts w ON w.user_id = u.id
  GROUP BY u.id, u.email, u.name, u.created_at
)
SELECT *,
  CASE
    WHEN workout_count >= 5 AND last_workout > NOW() - INTERVAL '14 days' THEN 'active'
    WHEN workout_count >= 1 AND last_workout < NOW() - INTERVAL '30 days'  THEN 'churned'
    WHEN workout_count = 0                                                 THEN 'ghost'
    ELSE 'other'
  END AS segment
FROM activity
ORDER BY segment, workout_count DESC;
```

`other` is the middle ground (has workouts, but neither active nor churned). Keep the label (`raw_segment` in the CSV) — if that bucket is large it means people are trying and drifting, which is a different problem from bouncing immediately. For the email, route by recency so nothing in it is false: last workout within 14 days → **active** template (they haven't stopped); 14–30 days → **churned** template.

---

## Step 3 — Personalization merge

Output one CSV: `outreach.csv`

| Column | Notes |
|---|---|
| `email` | |
| `first_name` | Fall back to the part before `@` if null, title-cased. Never send "Hey ," |
| `segment` | active / churned / ghost |
| `workout_count` | |
| `signup_month` | e.g. "April" — used in the ghost email |
| `last_workout_month` | e.g. "June" — used in the churned email |
| `personal_line` | One generated sentence, see below |

`personal_line` is the only generated text. One sentence, concrete, factual:

- active → `"You've logged 14 workouts since April, which puts you in a small group."`
- churned → `"You logged 4 workouts back in June and then stopped."`
- ghost → `"You signed up in May but never logged a workout."`

Keep it factual. No flattery, no "we noticed you've been crushing it." The point is to prove a human looked at their account.

**Exclusions:** filter out your own test accounts, any address matching your own domain, and obvious throwaways.

---

## Step 4 — Email templates

Three questions, hard cap. No links of any kind. No pitch, no feature announcements, no discount codes — the moment it becomes a sales email the honest answers stop.

### Active

> Subject: quick question about TenXRep
>
> Hey {first_name},
>
> I'm the person who built TenXRep — it's just me, no team.
>
> {personal_line} I'm trying to understand why. Three quick questions if you have two minutes:
>
> 1. What made you keep using it?
> 2. Which screen do you actually open most?
> 3. If it disappeared tomorrow, what would you miss?
>
> No wrong answers, and blunt is more useful than polite.
>
> Thanks,
> {your_name}

### Churned

> Subject: quick question about TenXRep
>
> Hey {first_name},
>
> I built TenXRep — solo, no team behind it.
>
> {personal_line} I'd really like to know why. Three questions:
>
> 1. What were you hoping it would do for you?
> 2. What made you stop?
> 3. Are you using something else now?
>
> I'm not trying to win you back — I just need to know what's broken. Harsh answers are the useful ones.
>
> Thanks,
> {your_name}

### Ghost

> Subject: quick question about TenXRep
>
> Hey {first_name},
>
> I'm the solo developer behind TenXRep.
>
> {personal_line} You're the person I most want to hear from. Three questions:
>
> 1. What made you download it in the first place?
> 2. What did you expect to see when you opened it?
> 3. What stopped you from logging a workout?
>
> Even a one-line answer helps. "Looked confusing" or "forgot about it" is genuinely useful data.
>
> Thanks,
> {your_name}

---

## Step 5 — Sending

The address matters less than the pattern. Use `you@tenxrep.com` if you have it — the recipient recognizes the domain from signup and it authenticates cleanly. Personal Gmail is fine as a fallback; a cold email from an unrecognized Gmail can read as phishing.

- **Individually.** No BCC, no "Dear user."
- **Plain text.** No HTML template, no logo, no unsubscribe footer.
- **Spread the send.** ~20/day over a few days, not 60 in ten minutes.
- **No links.** In a low-volume personal email, links are the strongest spam signal in the message — and there's nothing to click anyway.
- **Never** from `noreply@` or a transactional service (SendGrid/Resend/Mailchimp). Those land in Promotions; the whole point is the primary inbox.
- Same signature you'd use for any normal email.

**Don't have Claude Code send these.** Generate the CSV, then send by hand from your mail client. Automated sending is exactly the thing that makes them stop working.

---

## Step 6 — Handling replies

Reply to every single one, same day if possible, and ask **one** follow-up question. The second exchange is where the real answer usually shows up.

Log responses in a simple table: `email | segment | positioning_noun | mentioned_skill_tree | reason_stopped | verbatim_quote`.

`positioning_noun` is the important column — how they describe the product in their own words. If actives consistently reach for "the muscle map thing" or "the imbalance app," that's your positioning, handed over for free.

Expect: highest response from actives, lowest from ghosts. But ghosts carry the highest information per reply — one person saying "I opened it and there was nothing to look at" outweighs five actives saying they like the 3D model.

**Decision gate:** once ~8 replies are in, make the positioning call and unblock the Week 4+ work in the No-Regret Plan.
