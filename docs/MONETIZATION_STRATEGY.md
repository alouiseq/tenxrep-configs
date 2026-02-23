# TenXRep Monetization Strategy

## Overview

TenXRep uses a **freemium model** with a 14-day trial of all Pro features, followed by a restricted free tier and a single Pro subscription.

**Key Principles:**
- One flat price for all Pro features (no a la carte)
- Free tier builds the habit, Pro delivers the full experience
- 14-day trial gives users two full workout cycles to experience the value
- Free tier acts as a safety net to keep non-converters in the funnel

---

## Pricing Structure

### Single Pro Tier

One subscription unlocks everything. No feature bundles or separate add-ons.

**Why single tier:**
- Simplicity sells - "Free vs Pro" is a one-second decision
- Bundling increases perceived value
- Reduces code complexity (one `is_pro` flag vs multiple entitlements)
- A la carte pricing creates decision fatigue at this stage

**Competitor Reference:**
| App | Price | Notes |
|-----|-------|-------|
| Strong | $30/yr | 3 free templates, then paywall |
| Hevy | $24/yr | Free with ads + limits |
| FitBod | $80/yr | 3 free workouts total, then paywall |
| JEFIT | $70/yr | Free with limits |
| **TenXRep** | **$39.99/yr** | $5.99/mo or $39.99/yr (~44% savings) |

TenXRep has something no competitor offers (3D viz + tracking), but is web-only with no wearable integration. Price reflects unique value while staying competitive.

**Pricing:** $5.99/mo or $39.99/yr (~44% annual savings). Show pricing before signup for transparency.

---

## Feature Access Matrix

| Feature | Trial (14 days) | Free (post-trial) | Pro |
|---------|----------------|--------------------|-----|
| **Workout Tracking** | Unlimited | Unlimited | Unlimited |
| **Exercise Library** (96 exercises) | Full | Full | Full |
| **Exercise Hover** (muscle activation) | Yes | Yes | Yes |
| **3D Weekly Anatomy** (activation view, Simple mode) | Yes | Yes | Yes |
| **3D Weekly Anatomy** (volume view) | Yes | No | Yes |
| **3D Weekly Anatomy** (balance view) | Yes | No | Yes |
| **3D Advanced Mode** (237 meshes, 40+ sub-muscles) | Yes | No | Yes |
| **Recommendation Engine** (all 3 modes) | Yes | No | Yes |
| **Skills Tree Progressions** | Yes | No | Yes |
| **Progressive Overload Suggestions** | Yes | No | Yes |
| **Workout History** | Full | Last 2 weeks | Full |
| **Stats/Progress Page** | Full | Basic (last 2 weeks) | Full |
| **Visual Progression** (3D timeline) | Yes | No | Yes |
| **Custom Exercises** | Unlimited | Up to 5 | Unlimited |
| **Data Export** | Yes | No | Yes |

### Free Tier Philosophy — "Gate Depth, Not Surface"

**Give freely (habit builders):**
- Account creation + onboarding setup wizard
- Unlimited manual workout tracking
- Exercise library browsing (all 96 exercises)
- Muscle activation on exercise hover (the "wow" teaser)
- 3D Weekly Anatomy — Activation View in Simple mode (9 muscle groups)
- Up to 5 custom exercises

**Lock behind Pro (analytical depth):**
- 3D Volume View + Balance View (imbalance detection)
- 3D Advanced Mode (237 meshes, 40+ sub-muscles)
- Visual Progression (3D timeline across weeks)
- Recommendation engine (fullyAuto, partialAuto modes)
- Skills tree progressions
- Progressive overload suggestions
- Full workout history (beyond 2 weeks)
- Unlimited custom exercises
- Data export

### Conceptual Split

Free users see **what** muscles an exercise hits (educational/per-exercise).
Pro users see **how balanced their training is** over time (analytical/weekly).

The hover activation is the teaser that makes users think "I want to see my whole week like this."

---

## Trial Strategy

### Why 14 Days

- **Two full workout cycles.** Users complete 6-10 workouts across two weeks, fully experiencing the weekly anatomy view, progressive overload, and seeing how the 3D model evolves over multiple sessions.
- **Imbalance detection needs time.** The killer feature (3D imbalance visualization) only becomes meaningful after enough data accumulates — two weeks provides this.
- **Builds deeper habits.** By day 14, users have integrated TenXRep into their routine, making it harder to leave.
- **Free tier is the safety net.** Non-converters drop to restricted free, not a hard paywall. They stay in the funnel.

### Trial Experience Timeline

| Day | User Experience |
|-----|-----------------|
| Day 1 | Welcome + guided setup + first recommended workout |
| Day 2-3 | Second workout, progressive overload kicks in |
| Day 4-5 | Weekly anatomy view starts populating with data |
| Day 7 | Week 1 complete — full anatomy view, imbalance hints start showing |
| Day 8-10 | Week 2 begins, historical comparison becomes visible |
| Day 12-13 | Nudge: "Your trial ends soon — here's what you'll lose" |
| Day 14 | Trial ends, clear upgrade prompt showing locked features |

### Post-Trial Conversion Triggers

The restricted free tier creates **recurring friction**:
- They lose the Volume View, Balance View, and Advanced 3D mode they relied on
- They lose the recommendations and progressive overload suggestions
- History older than 2 weeks disappears
- Visual Progression (3D timeline) is gone
- Skills tree progressions locked

Free users still get the 3D Activation View (Simple mode) — enough to stay hooked, not enough to satisfy power users.

---

## Existing User Transition

### Beta Users

~13 beta users, rewarded based on engagement level. Activity tracking exists to classify users.

**Tiered Rewards:**

| Tier | Criteria | Reward |
|------|----------|--------|
| **Lifetime** | Most active users + provided feedback | Free Pro forever |
| **Gold** | Provided feedback + regularly active | 6 months free Pro |
| **Silver** | Completed onboarding + logged some workouts | 3 months free Pro |
| **Bronze** | Signed up + did onboarding only | 1 month free Pro |
| **Inactive** | Signed up, never onboarded or used | Standard 14-day trial |

**Implementation:** Flag each user's reward tier manually in the database (`pro_reward_tier` or similar). Send personalized email notification to each tier when monetization goes live.

### Beta Signup Waitlist

The current 100-cap beta signup list represents warm leads:
- Communicate the transition clearly before flipping the switch
- Give waitlist users priority access + trial

---

## Implementation Notes

### Technical Requirements

- [ ] Payment provider integration (Stripe recommended)
- [ ] Subscription management (create, cancel, reactivate)
- [ ] Webhook handling (payment events, trial expiration)
- [ ] `is_pro` flag on user model + trial expiration date
- [ ] Feature gating in frontend (check subscription status)
- [ ] Feature gating in backend (protect Pro-only endpoints)
- [ ] Trial countdown/notification system
- [ ] Upgrade/downgrade flow in UI
- [ ] Pricing page on marketing site

### Feature Gating Approach

Backend: Pro-only endpoints return 403 with upgrade prompt for free users.
Frontend: Pro features show a lock icon/overlay with upgrade CTA.

Keep it simple - one `is_pro` boolean + `trial_ends_at` timestamp on the user model.

---

## Metrics to Track

| Metric | What It Tells You |
|--------|-------------------|
| Trial-to-paid conversion rate | Is the trial experience compelling enough? |
| Free-to-paid conversion rate | Is the free tier creating "I need more" moments? |
| Time-to-first-workout (trial) | Is onboarding getting users to value fast? |
| Feature usage during trial | Which Pro features drive conversion? |
| Churn rate (monthly/annual) | Are paying users getting ongoing value? |
| Workout frequency (free vs Pro) | Are Pro users training more than free users? |

---

## Resolved Decisions

- [x] **Price:** $5.99/mo or $39.99/yr (~44% annual savings)
- [x] **Trial duration:** 14 days
- [x] **Pricing visibility:** Show before signup
- [x] **Workout tracking:** Unlimited for free (compete on depth, not surface)
- [x] **3D gating:** Free = Activation View (Simple mode). Pro = Volume View + Balance View + Advanced mode
- [x] **Imbalance detection:** Visual only for MVP (no nudges/alerts)
- [x] **Beta user reward:** Tiered — lifetime Pro (most active), 6mo/3mo/1mo (by engagement), standard trial (inactive). Email notification on launch.
- [x] **Grace period:** Immediate lock after trial (free tier is the safety net)
- [x] **Refund policy:** Standard 30-day refund
- [x] **Custom exercises:** 5 for free, unlimited for Pro (abuse prevention)
- [x] **Overtraining Red Zone:** MVP scope (Phase 1) — proactive alerts/toasts, not just visual color
- [x] **Visual Progression:** Phase 1 scope — 3D timeline slider across weeks

## Open Questions

- [ ] Skill tree gating — fully Pro or 1-2 free paths?
- [ ] Marketing budget and acquisition strategy
- [ ] When to add RevenueCat / native IAP

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-07 | Initial strategy document created |
| 2026-02-22 | Updated trial duration from 7 days to 14 days (consistent with STRATEGY.md) |
| 2026-02-22 | Finalized pricing: $5.99/mo, $39.99/yr. Unlimited free tracking. Gate depth not surface for 3D (free = Activation View Simple mode, Pro = Volume/Balance/Advanced). Show pricing before signup. Beta users get extended free Pro (3-6 months). Immediate lock after trial. 30-day refund. 5 custom exercises free, unlimited Pro. |
