# Engineering Patterns

Design and code patterns that hold across the TenXRep projects, with the reasoning and the incident behind each one.

**How this relates to the CLAUDE.md files:** those are auto-loaded into every session, so they carry terse imperative warnings (`Common Pitfalls to Avoid`) and link here. This doc is where the depth lives — read it before non-trivial work, and add to it when a correction turns out to generalise. Project-specific detail stays in its own project: [`tenxrep-api/docs/DATABASE.md`](https://github.com/alouiseq/tenxrep-api/blob/main/docs/DATABASE.md) for data migrations, [`tenxrep-web/docs/COMPONENTS.md`](https://github.com/alouiseq/tenxrep-web/blob/main/docs/COMPONENTS.md) for React conventions.

> **Links here are absolute on purpose.** This doc lives in the `tenxrep-configs` repo; the project directories are separate repos that it doesn't track, so a relative `../tenxrep-api/...` resolves in a local checkout but 404s on GitHub. See [Project Structure](../CLAUDE.md#project-structure).

**Last updated:** 2026-10-12

---

## 1. Pure rules live outside component files

**Pattern:** when a component's behaviour turns on a non-trivial rule, put the rule in a plain `.ts` module and have the component import it.

```
src/lib/trialBanner.ts     shouldShowTrialBanner(), threshold constants
src/lib/setLogging.ts      stepWeight(), blurOnEnter(), WEIGHT_STEP_LBS
src/components/*.tsx       imports them; exports only a component
```

**Why:**
- **Testable without a harness.** `shouldShowTrialBanner({ isTrial, trialExpired, daysLeft })` is seven assertions and no mocking. The same logic inline in the component needs `QueryClientProvider`, mocked hooks, and a render just to check a boolean.
- **Fast refresh keeps working.** Exporting a non-component from a `.tsx` trips ESLint's `react-refresh/only-export-components` and breaks HMR for that file.
- **The reasoning gets a home.** A constant named `TRIAL_BANNER_SHOW_AT_DAYS_LEFT` with a comment explaining the 14-day trial it's tuned for is self-documenting in a way `daysLeft <= 5` isn't.

**How to apply:** the shape is "functional core, imperative shell" — decisions in pure functions, I/O and rendering at the edges. If a component needs a comment to explain *why* it renders, that comment probably belongs next to an extracted function.

---

## 2. Verify a flag is populated before keying behaviour off it

**Pattern:** before gating UX on a boolean column, count how many rows actually have it set. A flag that looks authoritative can be nearly empty.

**Incidents (both 2026-09-27, while designing the set-logging work):**

| Flag | Looks like | Reality |
|---|---|---|
| `library_exercises.can_be_weighted` | "which exercises accept added weight" | true on **20 of 251**. Of 81 BODY/RINGS rows logged *with* a weight, **56** sit on exercises where it's `false` — Parallel Bar Dip, Elevated Pseudo Push-Up, Standing Calf Raises |
| `workout_exercises.is_weighted` | "was this set weighted" | true on **29 of 576** rows, while **175** rows carry a non-zero weight. The frontend ignores it and derives from `type` + `weight > 0` instead |

Gating "+ Add weight" on either would have hidden the control for the most commonly weighted calisthenics movements — the exact bug the design was trying to avoid.

**How to apply:** prefer **observed state** (does this row actually have a weight?) over **declared state** (does a flag say it could?). When a flag and the data disagree, that's a data-integrity bug worth its own ticket — don't build on top of it.

---

## 3. Derive magic numbers from logged data

**Pattern:** when a constant encodes a guess about user behaviour, check the database first and put the finding in the comment.

**Worked example.** The weight stepper moved 0.5 lb per tap — 270 taps to reach a 135 lb working weight. The data: of 416 non-zero weights logged, **338 are multiples of 5** and 379 of 2.5; only 37 need finer. So 5 is the right step, and `step="0.5"` stays on the input because 52.5 is the 3rd most common logged weight and must remain typeable. Reps chips are 8/10/12 because 8 and 10 alone are ~60% of all logged values.

**Why:** the old increment wasn't arbitrary, it was tuned for the rarest case. Without the query you can't tell those apart, and the constant becomes folklore nobody dares change.

**How to apply:** one read-only query beats an opinion. Then write the number *and* the evidence into the comment, so the next person can re-derive it instead of guessing at your intent.

---

## 4. Frontend types drift from API schemas

**Pattern:** a field the API returns can be missing from the TypeScript interface, so the data arrives and is silently discarded. Check the Pydantic schema before concluding something isn't available.

**Incidents:** `UserResponse` has returned `created_at` all along, but `User` in `useAuth.tsx` omitted it — the first attempt at the trial-banner gate assumed a backend change was needed. Same for `completed_at` on `BackendWorkout`: returned by `WorkoutResponse`, absent from the TS interface, unreferenced anywhere in `src/`.

**How to apply:** when a frontend change needs a field, grep `tenxrep-api/app/schemas/` first. Adding a field to the TS interface is usually the whole job. The reverse also holds — don't assume a TS interface is a complete picture of the response.

---

## 5. Read-only scripts, explicitly

**Pattern:** a script that exists to *read* production opens its session read-only and says so in the docstring.

```python
with engine.connect() as conn:
    conn.execute(text("SET default_transaction_read_only = on"))
```

Reference: `tenxrep-api/scripts/generate_outreach_csv.py`. Output containing user data is PII — write it outside the repo or gitignore it.

**Why:** ad-hoc analysis against prod is routine and useful; the guardrail is what makes it safe to run without re-reading the whole script. This is the complement to the rule that *state changes* belong in Alembic migrations, never scripts (`tenxrep-api/CLAUDE.md` pitfall #8) — read-only analysis is the legitimate remaining use for `scripts/`.

---

## 6. State the intent before building

Every backlog task gets a short what + why before implementation, so the approach can be green-lit or corrected. Being in the backlog means the *problem* is agreed, not the *approach*. Full statement of the agreement, and the worked example that produced it, is in [backlog.md](backlog.md#working-agreement--state-the-intent-before-building).

---

## 7. Brand colour goes through semantic tokens, and a foreground token travels with each fill

**Pattern:** brand colour is never a raw Tailwind palette class or a hex in a component. Both frontends define the same tokens in their global CSS and expose them in `tailwind.config.ts`:

```
--heat-1 / --heat-2 / --heat-3     yellow → orange → red, from the Handstand X mark
--heat-cta-end                     text-safe end stop for gradients that carry text
--heat-foreground                  dark ink; the ONLY text colour allowed on a heat fill
--cool-1 / --cool-2                the mark's blues
--destructive-text                 error text and icons (lighter than the fill in dark mode)

bg-heat-cta        primary CTA gradient        bg-heat-2      solid accent
bg-heat-headline   gradient titles             text-heat-2    accent icons and text
```

**Rules that the tokens encode:**
- **Orange `--heat-2` is the working accent.** Yellow and red appear only as the ends of gradients. `--heat-3` red is decorative: never a fill, never behind text, never a status.
- **Dark ink on heat, always.** White on `#FF8A1F` is 2.4:1; ink is 6.7:1. Use `text-heat-foreground`, not `text-primary-foreground` — in the web app's light theme `--primary-foreground` is white, so the "obvious" class fails contrast in exactly one theme.
- **Red means bad, and only bad.** Destructive moved to crimson-rose (hue ~346°) so it can't be mistaken for the heat ramp. Filled buttons use `bg-destructive text-destructive-foreground`; error *text* uses `text-destructive-text`, because a red dark enough to carry white text is too dark to read as text on a dark background.
- **Don't cross-fade blue into orange in one fill.** The midpoint is grey-brown. Text gradients get away with it via the tuned stops in `bg-heat-headline`; buttons and tiles are either all-cool or all-heat.
- **Raw `amber-*` / `yellow-*` / `orange-*` are status colours** (warnings, imbalance severity, category chips), not brand. They were left alone on purpose.

**Why (the incident):** the October 2026 rebrand replaced a yellow accent that had been applied three different ways — through `--primary`/`--accent`, through ~90 raw `yellow-500`/`yellow-600` classes, and through hex literals in CSS and email templates. Only the first kind changed when the tokens changed; the rest had to be found by grep across three repos, and each one needed a judgement call about whether that yellow meant "brand", "Pro", "achievement" or "warning". Several were also white text on yellow at under 3:1, which nobody had noticed because the colour and its text colour were chosen separately at each call site.

**Where the values live:** the token table, class recipes and logo files are documented in [`tenxrep-web/docs/BRAND.md`](https://github.com/alouiseq/tenxrep-web/blob/main/docs/BRAND.md).

**How to apply:** this is the design-token idea — name colours by role, not by value, and ship the fill and its legible foreground as a pair so contrast is decided once. When a new colour need comes up, ask what role it plays: if it's brand, use a heat/cool token; if it's status, use the status palette; if neither fits, add a token rather than a literal. Emails can't read CSS variables, so `tenxrep-api/app/services/email_service.py` repeats the hex values — a known duplicate to update by hand if the palette moves.

**Not yet on the ramp:** the 3D model's activation/volume scale and chart data colours still use their original palette. Moving them is a separate change, because heat red would then mean "high activation" right next to Red Zone alerts where red means "too much".

