# Third-Party Scripts & APIs — Audit and Migration Assessment

Observed on the live Webflow site (network capture, 2026-07-05). Verdict = what the static rebuild does.

## Keep

| Service | Detail | Assessment | Verdict |
|---|---|---|---|
| GA4 | `gtag.js`, measurement ID `G-WP6YL2W423` | Active analytics baseline (Search Console tied to it). Keep the same property so historical data continues. | **Kept** — loaded async in every page `<head>` |
| Google Ads | `AW-16658315612` (gtag config, doubleclick remarketing calls observed) | Conversion/remarketing tag. Only valuable if ads are running. Several requests returned 503 (ad blockers). **Confirm with Tammy whether Google Ads campaigns are active** — if not, drop to save ~80KB of JS. | **Kept for now** — same gtag loader, flagged for confirmation |

## Replaced / dropped

| Service | Detail | Assessment | Verdict |
|---|---|---|---|
| jQuery 3.5.1 | Webflow runtime dependency (~30KB gz) | 2020-era version, only there because Webflow requires it. Nothing in the rebuilt site needs it. | **Dropped** — vanilla JS |
| Webflow runtime | `webflow.schunk.*.js`, `webflow.*.js` (3 files) | Powers Webflow interactions/forms. Meaningless off-platform. | **Dropped** — CSS transitions + ~60 lines of vanilla JS |
| Lottie menu animation | `lottieflow-menu-nav-07…json` + player inside Webflow runtime | An animated hamburger icon. Absurd payload for the job. | **Dropped** — CSS-animated hamburger |
| Cloudflare Turnstile | `challenges.cloudflare.com/turnstile` | Injected by Webflow for form spam protection. Worth re-adding **with our own (free) site key when forms are wired to a backend** — not before. | **Deferred** — noted in form TODO |
| Webflow CDN | `cdn.prod.website-files.com` (CSS, JS, fonts, images) | Hosting artifact. Images/fonts currently still referenced from this CDN in the rebuild so pages render identically today. Must be localized before launch (`scripts/download-assets.sh` fetches everything into `/assets/`). **Risk: if the Webflow subscription is cancelled, CDN assets go away.** | **Transitional** — localize before DO launch |

## External dependencies to resolve

| Dependency | Detail | Risk |
|---|---|---|
| Jobs board iframe | `/apply-now` embeds an iframe from `https://itswrpd.wpcomstaging.com/` — a **WordPress staging domain belonging to WRPD** (the agency), which presumably wraps the Bullhorn ATS feed. | High. A staging domain can be deleted or password-protected at any time, it's a third party we don't control, and it's the entire job-seeker funnel. Options: (a) embed Bullhorn's own published job list directly, (b) ask WRPD to move it to a production domain, (c) rebuild the board against Bullhorn's API on our droplet. Needs a decision from Jake/Tammy before launch. |
| Form processing | All forms currently submit to Webflow (via **GET** — a known PIPEDA problem, since PII lands in URLs/logs). | Rebuild ships form UI only, `method="post"`, not wired. Backend decision pending (droplet endpoint vs Formspree/Basin). Do not launch without this. |
| Blog | Out of scope this phase; nav links point to the live `https://www.ondemandstaffing.ca/blog`. | Fine while Webflow is live; must be migrated or redirected before Webflow is cancelled. |

## Net performance effect

Live site page weight (home-v2): Webflow CSS (~1 file, all pages) + jQuery + 3 Webflow JS chunks + Lottie JSON + gtag ≈ **~350KB+ of JS alone**.
Rebuild: one hand-written CSS file, one small JS file, gtag. JS drops from ~350KB to **<5KB + gtag**. No render-blocking third-party requests; fonts `font-display: swap`; hero image eager + `fetchpriority="high"` (fixes the audited LCP issue).
