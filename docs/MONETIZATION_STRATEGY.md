# TenXRep Monetization Strategy

## Overview

TenXRep uses a **freemium model** with a 7-day trial of all Pro features, followed by a restricted free tier and a single Pro subscription.

**Key Principles:**
- One flat price for all Pro features (no a la carte)
- Free tier builds the habit, Pro delivers the full experience
- 7-day trial is enough because TenXRep's "aha" moment is instant (3D visualization)
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
| **TenXRep** | **TBD** | Suggested range: $30-60/yr |

TenXRep has something no competitor offers (3D viz + tracking), but is web-only with no wearable integration. Price should reflect both the unique value and the platform tradeoff.

**Price TBD** - finalize after initial conversion data from trial users.

---

## Feature Access Matrix

| Feature | Trial (7 days) | Free (post-trial) | Pro |
|---------|----------------|--------------------|-----|
| **Workout Tracking** | Unlimited | 3 per week | Unlimited |
| **Exercise Library** (96 exercises) | Full | Full | Full |
| **Exercise Hover** (muscle activation) | Yes | Yes | Yes |
| **Recommendation Engine** (all 3 modes) | Yes | No | Yes |
| **3D Weekly Anatomy** (volume view) | Yes | No | Yes |
| **3D Weekly Anatomy** (activation view) | Yes | No | Yes |
| **Skills Tree Progressions** | Yes | No | Yes |
| **Progressive Overload Suggestions** | Yes | No | Yes |
| **Workout History** | Full | Last 2 weeks | Full |
| **Stats/Progress Page** | Full | Basic (last 2 weeks) | Full |
| **Data Export** | Yes | No | Yes |

### Free Tier Philosophy

**Give freely (habit builders):**
- Account creation + onboarding setup wizard
- Manual workout tracking (up to 3/week)
- Exercise library browsing (all 96 exercises)
- Muscle activation on exercise hover (the "wow" teaser)

**Lock completely (Pro only):**
- Recommendation engine (fullyAuto, partialAuto modes)
- Skills tree progressions
- Weekly 3D anatomy views (volume + activation)
- Progressive overload suggestions
- Full workout history
- Data export

### Conceptual Split

Free users see **what** muscles an exercise hits (educational/per-exercise).
Pro users see **how balanced their training is** over time (analytical/weekly).

The hover activation is the teaser that makes users think "I want to see my whole week like this."

---

## Trial Strategy

### Why 7 Days (Not 14)

- **TenXRep's "aha" is instant.** 3D visualization hits on first workout. Recommendations show value day 1. No need for 2 weeks to "get it."
- **7 days = one natural workout cycle.** Users complete 3-5 workouts, see the weekly anatomy fill up, and experience progressive overload suggestions.
- **Shorter trial creates urgency.** 14 days lets people procrastinate. 7 days drives engagement from day 1.
- **Free tier is the safety net.** Non-converters drop to restricted free, not a hard paywall. They stay in the funnel.

### Trial Experience Timeline

| Day | User Experience |
|-----|-----------------|
| Day 1 | Welcome + guided setup + first recommended workout |
| Day 2-3 | Second workout, progressive overload kicks in |
| Day 4-5 | Weekly anatomy view starts populating with data |
| Day 5-6 | Nudge: "Your trial ends tomorrow - here's what you'll lose" |
| Day 7 | Trial ends, clear upgrade prompt showing locked features |

### Post-Trial Conversion Triggers

The restricted free tier creates **recurring friction**:
- Every week users hit the 3 workout limit
- They lose the recommendations they relied on
- History older than 2 weeks disappears
- The weekly anatomy view they loved is gone

These aren't one-time "meh" moments - they repeat weekly, driving conversion.

---

## Existing User Transition

### Beta Users

Beta users provided early feedback and should be rewarded:
- **Option A:** Lifetime discount (e.g., 30-50% off forever)
- **Option B:** Extended free Pro access (e.g., 3-6 months)
- **Option C:** Grandfathered pricing at a lower rate

**Recommendation:** Give beta users a meaningful reward. They'll be the best word-of-mouth advocates and early testimonials.

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
| Workout frequency (free vs Pro) | Is the 3/week limit the right threshold? |

---

## Open Questions

- [ ] Final price point (monthly + annual pricing)
- [ ] Annual discount percentage (typical: 20-40% off monthly)
- [ ] Beta user reward (discount vs extended free)
- [ ] Grace period after trial (immediate lock vs 2-3 day grace)?
- [ ] Refund policy details
- [ ] Whether to show pricing before or after signup

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-07 | Initial strategy document created |
