# ODS Brand Identity — Design Tokens & Notes

Extracted from the live Webflow site (ondemandstaffing.ca) on 2026-07-05. Source of truth for the static rebuild.

## Typography

**Family:** Plus Jakarta Display (self-hosted woff2, referred to as "Jakarta Display" in CSS). Fallback stack: `"Jakarta Display", "Plus Jakarta Sans", system-ui, sans-serif`.

| Weight | File | Usage |
|---|---|---|
| 400 Regular | PlusJakartaDisplay-Regular.woff2 | Body text |
| 500 Medium | PlusJakartaDisplay-Medium.woff2 | Subheads, nav |
| 700 Bold | PlusJakartaDisplay-Bold.woff2 | Headings, buttons, stats |

**Scale (desktop):**

| Element | Size / Line height | Weight | Colour |
|---|---|---|---|
| Body | 18px / 32px | 400 | #47505C |
| H1 | 65px / 70px | 700 | #05152E |
| H2 | 60px / 64px | 700 | #05152E |
| H3 (dark sections) | 60px / 66px, -1.2px tracking | 700 | #FFFFFF |
| Buttons | 16–18px | 700 | — |

Note: the template's heading scale is aggressive (H2 at 60px). Recommend clamping with `clamp()` for fluid sizing — e.g. H1 `clamp(2.5rem, 5.5vw, 4.06rem)` — instead of the fixed Webflow breakpoint jumps.

## Colours

| Token | Hex | RGB | Usage |
|---|---|---|---|
| `--navy-900` | #05152E | 5,21,46 | Headings, dark sections |
| `--body` | #47505C | 71,80,92 | Body text (dominant colour on site) |
| `--blue-700` (primary) | #274899 | 39,72,153 | Primary buttons, nav CTA, dark section bg |
| `--blue-500` (accent) | #153CF5 | 21,60,245 | Links, hover states, card shadow tint |
| `--amber` | #FFBA19 | 255,186,25 | Large CTAs, accents |
| `--amber-alt` | #FFC225 | 255,194,37 | Secondary amber (consolidate → one amber) |
| `--neutral-100` | #F7F7FB | 247,247,251 | Alternate section background |
| `--neutral-200` | #E5E5EF | — | Light fills |
| `--border` | #CED3D9 | — | Input borders, dividers |
| `--error` | #FF4545 | — | Form errors |

### Accessibility notes (carried from Tim's audit + verified)

- **Amber #FFBA19 on white fails WCAG AA** (≈1.7:1). On the live site, one large button uses white text on amber (worse). In the rebuild, amber buttons use **navy #05152E text** (≈11:1 on amber) — visual style preserved, contrast fixed.
- Two ambers exist on the live site (#FFBA19 / #FFC225). Rebuild consolidates to #FFBA19.
- Blue #274899 on white passes AA for all text sizes.

## Spacing & Layout

| Token | Value |
|---|---|
| Section padding | 120px top/bottom (desktop) → recommend 80px @≤991px, 64px @≤767px |
| Container | max-width 1300px, 24px side padding |
| Button padding | 18px 24px (header), 22px 36px (large) |
| Button radius | 4px |
| Card radius | 24px |
| Card shadow | soft, blue-tinted rgba(21,60,245,~0.07) |
| H1 margin-bottom | 24px |

Webflow breakpoints were 991 / 767 / 479px. Rebuild keeps these as reference but uses fluid type + `minmax()` grids so fewer overrides are needed.

## Logos & Marks

- Primary logo (transparent, colour): `636f4735f0039426413a06ec_ODS Revised LOgo Transparent.png`
- White-on-navy variant (OG image): `636f47163b9c9d27d109bc9c_ODS LogoRevisionFInalwWhite.png`
- Favicon: `63fac24c1ed05186cfc92402_supersmall.png`; touch icon: `63fac25369b16e1990dc83dd_small.png`

## Voice & recurring brand elements

- Tagline: **"Because Work Matters."** (footer, newsletter block)
- Stats bar used sitewide: 5,015 jobs posted · 3,000+ successful hires · 1,532 verified companies · 10+ years experience
- Local-first language: Niagara, St. Catharines, Welland appear in nearly every H1/meta
- Two-audience architecture: employer (primary) vs job-seeker journeys, mirrored nav/footers

## Recommendations summary

1. Consolidate the two ambers; use amber only with navy text.
2. Replace fixed heading sizes with `clamp()` fluid type.
3. Kill template leftovers: "Jobs Webflow Template" alt text, BRIX blue #153CF5 can be folded into #274899 usage review (kept for now as link colour).
4. Section rhythm 120px is generous but on-brand; keep, reduce on mobile.
5. Dynamic copyright year (live site says 2024 on most pages, 2025 on /contact).
