# TenXRep heat palette: token changes (mockup proposal)

Source of the old values: the live stylesheet `tenxrep.com/_next/static/css/35569e1d6a7107cd.css` (shadcn HSL tokens; the site renders with `<html class="dark">`).
New values come from the final-v3 logo: hot `#FFD728` / `#FF8A1F` / `#FF3B30`, cool `#3B82FF` / `#1F56D6`. Navy and blue tokens are kept.
The full override used for the mockups is in `heat-override.css`.

## Theme tokens

| Token | Theme | Old | New | Note |
|---|---|---|---|---|
| `--primary` | dark | `45 100% 58%` `#FFC929` | `29 100% 56%` `#FF8A1F` | Main accent: icons, check marks, `text-primary`, headline gradient end |
| `--primary-foreground` | dark | `222 30% 15%` `#1B2232` | unchanged | Dark ink on orange is 6.7:1 |
| `--ring` | dark | `45 100% 58%` `#FFC929` | `29 100% 56%` `#FF8A1F` | Focus ring. Orange on `#0E121B` is 8.0:1 |
| `--accent` | dark | `222 67% 45%` `#2654C0` | unchanged | Optional nudge to the logo blue: `222 75% 48%` `#1F56D6` |
| `--destructive` | dark | `0 62.8% 50%` `#D02F2F` | `346 75% 52%` `#E02954` | Crimson-rose, moved away from heat red. White text on it is 4.55:1 |
| `--destructive-text` (new) | dark | n/a | `347 96% 64%` `#FB4D72` | Error text and icons on dark, 5.7:1 on bg |
| `--accent` | light | `45 100% 58%` `#FFC929` | `29 100% 56%` `#FF8A1F` | Light theme uses yellow as its accent |
| `--accent-foreground` | light | `222 30% 15%` | unchanged | Dark ink |
| `--primary`, `--ring` | light | `222 67% 33%` `#1C3E8D` | unchanged | Navy |
| `--destructive` | light | `0 84.2% 60.2%` `#EF4444` | `347 77% 50%` `#E21D48` | Old value failed with white text (3.8:1). New is 4.66:1 |
| `--destructive-text` (new) | light | n/a | `347 77% 50%` `#E21D48` | 4.66:1 on white |
| `--heat-1/2/3` (new) | both | n/a | `49 100% 58%` `#FFD728`, `29 100% 56%` `#FF8A1F`, `3 100% 59%` `#FF3B30` | Logo hot stops |
| `--heat-cta-end` (new) | both | n/a | `14 100% 58%` `#FF5A2A` | Text-safe end stop for CTAs (ink 5.1:1). Use instead of `#FF3B30` under text |
| `--cool-1/2` (new) | both | n/a | `218 100% 62%` `#3B82FF`, `222 75% 48%` `#1F56D6` | Logo cool stops |
| `--foreground`, `--muted-foreground`, `--secondary-foreground`, `--card-foreground` | dark | hue 45 (warm off-white) | unchanged | Works with orange; optional hue 30 |
| `--background`, `--card`, `--muted`, `--secondary`, `--border`, `--input` | both | navy greys | unchanged | |
| `--chart-1..5` | both | | unchanged | Not used on the homepage |

## Hard-coded Tailwind classes found in the homepage HTML

| Class | Where | Old | New |
|---|---|---|---|
| `text-yellow-500` | Pro plan crown and check marks | `#EAB308` | `#FF8A1F` |
| `from-yellow-500` | Pro CTA, "14-DAY FREE TRIAL" badge | `#EAB308` | `#FF8A1F` (the pair is overridden to the heat CTA below) |
| `to-yellow-600` | same | `#CA8A04` | `#FF5A2A` |
| `from-yellow-500/5` | Pro card wash | `rgba(234,179,8,.05)` | `rgba(255,138,31,.05)` |
| `border-yellow-500/50` | Pro card border | `rgba(234,179,8,.5)` | `rgba(255,138,31,.5)` |
| `text-white` on the yellow gradient | Pro CTA and badge | white (1.9 to 2.9:1, fails) | ink `#1B2232` |

## Component overrides (in `heat-override.css`)

- **Heat CTA.** Applies to the hero "Sign Up Free" (`a.bg-gradient-to-r.from-accent.to-primary`) and the Pro CTA/badge. Gradient `#FFD728 → #FF8A1F 55% → #FF5A2A`, ink text. The old hero CTA put dark ink on blue `#2654C0` at the left end (2.35:1), an existing contrast bug that this also fixes.
- **Headline "See Your Muscles in 3D".** Was `from-accent to-primary`, blue to yellow with a muddy grey-olive middle. Now cool to hot like the mark: `#3B82FF 0% → #4F8DFF 34% → #FFB224 47% → #FF8A1F 70% → #FF5A2A 100%`. My first try with full red and a long yellow segment read as a rainbow, so I dropped that.
- **Hero background wash.** Was `from-primary/20 via-primary/10 to-accent/20`. With orange it turned the whole hero rust-brown, so it's now cool navy with a faint ember glow top-left: `radial(hsl(14 100% 58% / .13))` plus `accent/.06 → .22`.
- **Header and footer logo.** Swapped to `final-v3/lockup-dark-bg.svg` at 40 px (desktop) / 34 px (mobile) tall, and the `brightness-75 contrast-125` filter classes are dropped.

## Button text colour guidance

- **Orange `#FF8A1F` and yellow-to-orange buttons:** always dark ink `#1B2232` (6.7 to 11.4:1). White on `#FF8A1F` is 2.36:1 and fails.
- **Anything ending in red:** end the gradient at `#FF5A2A` (ink 5.1:1), not `#FF3B30` (ink 4.48:1, white 3.55:1, both under 4.5). Keep `#FF3B30` for decorative use only: logo, headline tail, glows, never behind body text.
- **Blue buttons (`--accent` `#2654C0`):** white text (6.75:1). Never ink on blue.
- **Focus:** the 2 px orange ring with a 2 px background offset reads clearly on dark (8:1). The light theme keeps the navy ring.

## Error red recommendation

The app already uses red for meaning: red hearts and trash icons, red "-6 reps/set" regressions, "Red Zone" overtraining alerts. Brand heat red (hue 3°) next to the old destructive red (hue 0°) would be indistinguishable.

- Never use heat red as a solid fill, or as solid text or badge colour. Brand accent = orange; red only appears as the tail of a heat gradient.
- Move destructive/error to crimson-rose, about hue 346°:
  - dark theme: `--destructive` `#E02954` (white text 4.55:1), `--destructive-text` `#FB4D72`
  - light theme: `#E21D48`
- Always pair an error with an icon and text label, not colour alone.
