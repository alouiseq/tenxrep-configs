# TenXRep rebrand: implementation brief for Claude Code

You are implementing an approved rebrand in the TenXRep codebase: Next.js, Tailwind, shadcn-style HSL CSS tokens. It covers the marketing site (tenxrep.com) and the web app (app.tenxrep.com), both on Vercel, plus the iOS app icon. Everything you need is in this package. Paths below are relative to this file.

## Goal
1. Replace the old logo (navy circle, yellow ring, "10X / REP") with the new **Handstand X** mark everywhere: header, footer, favicons, manifest, Open Graph, iOS app icon.
2. Replace the yellow accent (`#FFC929`, `45 100% 58%`) with a **heat accent** (yellow → orange → red), keeping the navy/blue base.
3. Move destructive/error colour to a distinct crimson-rose so brand heat never reads as an error.

## Design rationale
- The logo is a heatmap X: hot yellow→red legs over cool blue arms, echoing the app's 3D muscle-activation model. The UI accent should come from the same ramp.
- Orange `#FF8A1F` is the working accent (solid fills, icons, focus). Yellow and red appear only as the ends of gradients.
- Red already means "bad" in the app (Red Zone alerts, regressions, delete), so heat red `#FF3B30` is decorative only and errors move to crimson-rose.

## Rules
- Work on a new branch (`rebrand/heat-palette`). Open a PR. **Do not push to main.**
- Implement natively in the codebase's CSS variables and Tailwind config. `reference/heat-override.css` is the mockup injection: use it as a spec, do not paste it in as-is.
- If tenxrep.com and app.tenxrep.com are separate projects or packages, apply every step to both.

## Step 1: Locate the files to change
Run from the repo root, excluding node_modules, .next and build output:
```bash
rg -n --hidden -g '!node_modules' -g '!.next' -g '!dist' -g '!*.lock' \
  -e 'yellow-(300|400|500|600|700)' -e 'amber-(400|500|600)' \
  -e '#?FFC929' -e '#?FFD728' -e '#?EAB308' -e '#?CA8A04' -e '#?1a3a7a' \
  -e '45 100% 58%' -e '0 62\.8% 50%' -e '0 84\.2% 60\.2%' \
  -e 'tenxrep-badge-wordmark-brand-combo' -e 'logo-favicon' -e 'apple-touch-icon' \
  -e 'og:image|openGraph|twitter:|apple-itunes-app|itunes' -e 'site\.webmanifest|manifest'
rg -n -g '!node_modules' -l -e '--primary:' -e '--accent:' -e '--destructive:'   # globals.css (usually app/globals.css or styles/globals.css)
ls tailwind.config.* postcss.config.* app/layout.* src/app/layout.* 2>/dev/null   # Tailwind config + root layout metadata
rg -n -g '!node_modules' -e '<img|<Image' -e 'alt="TenXRep"'                    # logo components (header, footer, app shell)
```
Known from the live site:
- The header and footer render `<img alt="TenXRep" src="/tenxrep-badge-wordmark-brand-combo.svg">`. The header img has classes `h-12 sm:h-14 w-auto brightness-75 contrast-125 dark:brightness-100 dark:contrast-100`; the footer img has `h-10 sm:h-12`.
- `<html class="dark">` is set, so the dark tokens are the ones you see.
- The hard-coded yellows are on the Pro pricing card. The hero CTA and headline use `bg-gradient-to-r from-accent to-primary`.

## Step 2: Tokens (globals.css)
Keep the existing HSL-triplet format (`H S% L%`, used as `hsl(var(--x))`).

**Light theme (`:root`)**
| Token | Old | New |
|---|---|---|
| `--accent` | `45 100% 58%` | `29 100% 56%` (#FF8A1F) |
| `--accent-foreground` | `222 30% 15%` | unchanged |
| `--destructive` | `0 84.2% 60.2%` | `347 77% 50%` (#E21D48) |
| `--destructive-foreground` | `0 0% 100%` | unchanged |
| `--destructive-text` | (new) | `347 77% 50%` |
| `--primary`, `--ring` | `222 67% 33%` | unchanged (navy) |

**Dark theme (`.dark`)**
| Token | Old | New |
|---|---|---|
| `--primary` | `45 100% 58%` | `29 100% 56%` (#FF8A1F) |
| `--primary-foreground` | `222 30% 15%` | unchanged (dark ink on orange = 6.7:1) |
| `--ring` | `45 100% 58%` | `29 100% 56%` |
| `--accent` | `222 67% 45%` | unchanged (blue) |
| `--destructive` | `0 62.8% 50%` | `346 75% 52%` (#E02954) |
| `--destructive-foreground` | `0 0% 100%` | unchanged |
| `--destructive-text` | (new) | `347 96% 64%` (#FB4D72) |

**New tokens. Add to both `:root` and `.dark` (same values):**
```css
--heat-1: 49 100% 58%;        /* #FFD728 */
--heat-2: 29 100% 56%;        /* #FF8A1F */
--heat-3: 3 100% 59%;         /* #FF3B30 decorative only */
--heat-cta-end: 14 100% 58%;  /* #FF5A2A text-safe gradient end */
--cool-1: 218 100% 62%;       /* #3B82FF */
--cool-2: 222 75% 48%;        /* #1F56D6 */
```
Put the light-only overrides in `:root` **before** `.dark`, or scope them with `html:not(.dark)`. `:root` and `.dark` have equal specificity, so a later `:root` block leaks into dark mode. (This bug showed up in the mockup.)

**Tailwind config.** Extend `theme.extend`:
```js
colors: {
  heat: { 1: 'hsl(var(--heat-1))', 2: 'hsl(var(--heat-2))', 3: 'hsl(var(--heat-3))', end: 'hsl(var(--heat-cta-end))' },
  cool: { 1: 'hsl(var(--cool-1))', 2: 'hsl(var(--cool-2))' },
  destructive: { DEFAULT: 'hsl(var(--destructive))', foreground: 'hsl(var(--destructive-foreground))', text: 'hsl(var(--destructive-text))' },
},
backgroundImage: {
  'heat-cta': 'linear-gradient(90deg, hsl(var(--heat-1)) 0%, hsl(var(--heat-2)) 55%, hsl(var(--heat-cta-end)) 100%)',
  'heat-headline': 'linear-gradient(90deg, #3B82FF 0%, #4F8DFF 34%, #FFB224 47%, #FF8A1F 70%, #FF5A2A 100%)',
},
```
(Keep the existing `destructive` keys if already defined; just add `text`. The live CSS is Tailwind v3, where `hsl(var(--x))` colours support `/opacity` modifiers. If the repo is on Tailwind v4, add the same colours and gradients in the CSS `@theme inline` block instead.)

## Step 3: Class replacements
| Find | Replace with |
|---|---|
| `text-yellow-500` (crown and check icons) | `text-primary` (#FF8A1F) |
| `bg-gradient-to-r from-yellow-500 to-yellow-600 text-white` (Pro CTA, "14-DAY FREE TRIAL" badge) | `bg-heat-cta text-primary-foreground` (dark ink) |
| `from-yellow-500/5` | `from-heat-2/5` |
| `border-yellow-500/50` | `border-heat-2/50` |
| Hero CTA `text-primary-foreground ... bg-gradient-to-r from-accent to-primary` | `bg-heat-cta text-primary-foreground` (removes the dark-ink-on-blue bug, 2.35:1) |
| Headline span `bg-gradient-to-r from-accent to-primary bg-clip-text text-transparent` | `bg-heat-headline bg-clip-text text-transparent` |
| Hero wash `absolute inset-0 bg-gradient-to-br from-primary/20 via-primary/10 to-accent/20` | `bg-[radial-gradient(ellipse_60%_70%_at_0%_0%,hsl(var(--heat-cta-end)/0.13),transparent_70%),linear-gradient(to_bottom_right,hsl(var(--accent)/0.06),hsl(var(--accent)/0.08)_45%,hsl(var(--accent)/0.22))]` (orange at 20% turns the hero rust-brown) |
| `text-destructive` used for error **text/icons** | `text-destructive-text`. Keep `bg-destructive` + `text-destructive-foreground` for filled buttons |
| Any other `yellow-*` / `amber-*` / `#FFC929` / `#FFD728` UI accent found by the Step 1 search | `primary` (dark) / `accent` (light) or `heat-*`, per the component rules below |

The other `from-primary/10 ... to-accent/10` card washes need no edits; they follow the tokens.

## Step 4: Component rules
- **Primary CTA:** `bg-heat-cta` (#FFD728 → #FF8A1F → #FF5A2A) with **dark ink** text `#1B2232` (`text-primary-foreground`). Never white text on yellow or orange.
- **Solid accent** (buttons, pills, sliders, selected states, icons): `#FF8A1F` with dark ink text.
- **Blue buttons** (`--accent` in dark): white text.
- **Heat red `#FF3B30`:** decorative only (logo, headline tail, glows). Never a solid fill, never behind text, never for status.
- **Errors/destructive:** crimson-rose tokens above. Always pair with an icon and label, not colour alone.
- **Focus ring:** orange in dark (`--ring` 29 100% 56%) with the existing `ring-2 ring-offset-2 ring-offset-background`. Light theme keeps the navy ring.

## Step 5: Logo, favicons, metadata
Assets are in `assets/`. Pick **one** of the two icon options below and don't mix them.

**Option A: `public/` files plus the metadata API (works with Pages or App Router)**
- Copy `assets/public/*` into `public/`:
  - `favicon.ico`, `favicon.svg`, `favicon-16.png`, `favicon-32.png`
  - `apple-touch-icon.png`, `icon-192.png`, `icon-512.png`
  - `site.webmanifest`, `og-image.png`
  - `brand/` (lockups, wordmarks, `icon.svg`, `icon-1024.png`)
- Delete or replace any existing `app/favicon.ico` so it doesn't override.
- In the root `app/layout.tsx`:
```ts
export const metadata: Metadata = {
  metadataBase: new URL('https://tenxrep.com'),   // app: https://app.tenxrep.com
  icons: {
    icon: [
      { url: '/favicon.ico', sizes: '16x16 32x32 48x48' },
      { url: '/favicon.svg', type: 'image/svg+xml' },
      { url: '/favicon-32.png', type: 'image/png', sizes: '32x32' },
      { url: '/favicon-16.png', type: 'image/png', sizes: '16x16' },
    ],
    apple: [{ url: '/apple-touch-icon.png', sizes: '180x180' }],   // must be PNG; the current site serves an SVG
  },
  manifest: '/site.webmanifest',
  openGraph: {
    title: 'TenXRep: See Your Muscles in 3D',
    description: 'Calisthenics training with a 3D muscle-activation body model.',
    url: 'https://tenxrep.com', siteName: 'TenXRep', type: 'website',
    images: [{ url: '/og-image.png', width: 1200, height: 630, alt: 'TenXRep logo, See Your Muscles in 3D' }],
  },
  twitter: { card: 'summary_large_image', images: ['/og-image.png'] },
  itunes: { appId: '6760636226' },   // renders <meta name="apple-itunes-app" content="app-id=6760636226">
};
export const viewport: Viewport = { themeColor: '#0E121B' };
```
- Keep the existing title and description copy if already set; only add the missing fields.
- If the Pages Router is used instead, add the equivalent `<link>`/`<meta>` tags in `_document`/`_app`. The `og:image` URL must be absolute: `https://tenxrep.com/og-image.png`.

**Option B: App Router file conventions**
- Copy `assets/app-router/app/*` into `app/`:
  - `favicon.ico`
  - `icon.svg` (small-size variant) and `icon1.png` (512 px)
  - `apple-icon.png` (180 px)
  - `opengraph-image.png` + `opengraph-image.alt.txt`
  - `twitter-image.png` + `twitter-image.alt.txt`
- Next generates the tags itself. Still copy `assets/public/site.webmanifest`, `icon-192.png`, `icon-512.png` and `brand/` into `public/`.
- Set `metadataBase`, `manifest`, `itunes` and `viewport.themeColor` as in Option A. Remove `icons`/`openGraph.images` from the metadata so they don't duplicate.

**Header and footer logo:** replace `/tenxrep-badge-wordmark-brand-combo.svg` with `/brand/lockup-dark-bg.svg`.
- Header: `h-9 sm:h-10 w-auto` (mobile 34-36 px, desktop 40 px). The new file is tightly cropped; the old SVG had large padding.
- Footer: `h-8 sm:h-9`.
- Remove the `brightness-75 contrast-125 dark:brightness-100 dark:contrast-100` classes.
- Use `/brand/lockup-light-bg.svg` on any light background.
- Keep `alt="TenXRep"` and `priority` on the header. Set `width`/`height` to the new aspect ratio: the lockups are viewBox `1192×288` (4.14:1), e.g. `width={166} height={40}`; the wordmark is `878×188`; the icon is square.
- In the web app shell (app.tenxrep.com, top-left logo with the tagline below), use `/brand/icon.svg` for the badge and `/brand/wordmark-dark-bg.svg` for the text. See `reference/mockups/dashboard-desktop-before-after.png`.
- After the swap, delete the old logo files (`tenxrep-badge-wordmark-brand-combo.svg`, `logo-favicon.svg`, old favicon) only if nothing references them any more. Search for them first.

## Step 6: iOS app icon
- Replace the contents of the Xcode asset catalog's `AppIcon.appiconset` (usually `<App>/Assets.xcassets/AppIcon.appiconset/`) with `assets/ios/AppIcon.appiconset/`. That's `AppIcon-1024.png` (1024×1024, RGB, no alpha, sRGB) plus a single-size `Contents.json` (Xcode 14+ format).
- Delete the old per-size PNGs.
- Make sure the target's "App Icon" build setting (`ASSETCATALOG_COMPILER_APPICON_NAME`) is `AppIcon`.
- Upload the same PNG to App Store Connect when the icon ships, so the Smart App Banner and the site match.
- If the iOS app has its own accent colour (`AccentColor.colorset` or a theme file), apply the same rule as the web: yellow accent becomes `#FF8A1F` with dark ink text; destructive becomes `#E02954` (dark) / `#E21D48` (light).

## Do not change
- Navy and grey tokens: `--background`, `--foreground`, `--card*`, `--popover*`, `--secondary*`, `--muted*`, `--border`, `--input`, light `--primary`/`--ring`, dark `--accent`, `--radius`, `--chart-*`.
- Layout, spacing, typography, copy and text content, routes, component structure.
- Data colours in charts and the 3D model (that's the optional follow-up below, in a separate PR).
- Success greens and blue info colours.

## Optional follow-up (separate PR, ask first)
1. **3D model activation scale:** it currently uses purple/blue/green/yellow (and blue shades for volume). Move it onto the brand ramp so the model matches the logo: cool `#1F56D6` → `#3B82FF` for low, heat `#FFD728` → `#FF8A1F` → `#FF3B30` for high. Keep the legend labels.
2. **Dashboard gradient buttons** ("Add Exercises", "Recommend", "Finish Workout", selected day card): these are blue→yellow today and become blue→grey→orange, with a muddy grey middle. Make them either solid `bg-primary` with dark ink, or `bg-heat-cta`. Don't cross-fade blue and orange in one gradient.

## Acceptance checklist
- [ ] Step 1 search returns no `yellow-*`, `amber-*`, `#FFC929`, `#FFD728`, `#EAB308`, `#CA8A04`, or `45 100% 58%` in UI code. The only allowed hits are the `--heat-1` token and its comment.
- [ ] Contrast (WCAG):
  - dark ink `#1B2232` on `#FF8A1F`: 6.7:1
  - ink on `#FFD728`: 11.4:1
  - ink on `#FF5A2A`: 5.1:1
  - white on `#2654C0`: 6.75:1
  - white on `#E02954`: 4.55:1; white on `#E21D48`: 4.66:1
  - `#FB4D72` on `#0E121B`: 5.7:1
  - orange focus ring on `#0E121B`: 8.0:1
  - No white text on yellow or orange; no text on `#FF3B30`.
- [ ] Visual match with `reference/mockups/desktop-hero-before-after.png`, `reference/mockups/mobile-hero-before-after.png`, `reference/mockups/bonus-pricing-before-after.png` and `reference/mockups/dashboard-before-after.png` (right-hand "after" side) at 1440×900 and 390×844.
- [ ] Dark-mode `--accent` is still blue (the video/card borders and shadows are blue, not orange). Checks for the token leak.
- [ ] Keyboard focus visible on every button and link (orange ring on dark).
- [ ] Destructive/error UI renders crimson-rose and is clearly different from heat accents.
- [ ] `/favicon.ico`, `/favicon.svg`, `/apple-touch-icon.png`, `/icon-192.png`, `/icon-512.png`, `/site.webmanifest`, `/og-image.png` return 200 on the Vercel preview (or the app/ convention equivalents appear in `<head>`).
- [ ] The new tab icon shows in Chrome and Safari, including after a hard refresh.
- [ ] The rendered `<head>` contains `apple-touch-icon` (PNG), `og:image` (absolute URL, 1200×630), `twitter:card=summary_large_image`, `apple-itunes-app` `app-id=6760636226`, and `theme-color`.
- [ ] The OG preview validates on the preview URL (opengraph.xyz, LinkedIn Post Inspector, or `curl -s <url> | rg 'og:|twitter:'`).
- [ ] The iOS project builds, and the new icon shows on the simulator home screen.
- [ ] `npm run build` and lint pass; no layout or copy diffs in the PR beyond logo sizing.
- [ ] PR from `rebrand/heat-palette` with before/after screenshots attached.

## Package contents
- `assets/public/`: Option A files for `public/`.
- `assets/app-router/app/`: Option B files for `app/`.
- `assets/ios/AppIcon.appiconset/`: iOS icon.
- `assets/source/`: `og-image.svg` and `favicon-16.svg` (editable vectors, not needed at runtime).
- `reference/palette-tokens.md`: the token table with notes.
- `reference/heat-override.css`: the CSS used for the mockups (spec only).
- `reference/logo-presentation-final-v3.png`: logo sizes and lockups.
- `reference/mockups/*.png`: before/after mockups.
- Palette hex values:
  - heat `#FFD728 / #FF8A1F / #FF3B30`, CTA end `#FF5A2A`
  - cool `#3B82FF / #1F56D6`
  - logo tile navy `#18306A → #0E1D47`
  - site background (dark) `#0E121B`
  - ink `#1B2232`
