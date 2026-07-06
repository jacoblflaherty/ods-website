# Migration Checklist — every Webflow page accounted for

Source of truth: Webflow Pages API (site 636d6d9c18e574a88037d5d7), pulled 2026-07-05 after the
first cutover attempt missed 6 service pages. **Nothing may be re-cut to DNS until every row
below is verified by Jake.**

## ✅ Migrated to static site (30 HTML pages)

| Webflow page | Static path | SEO meta parity |
|---|---|---|
| Home (splash) `/` | `/index.html` | ✅ Rebuilt 2026-07-05 from archived Webflow markup + CDN CSS (photo bg, colour logo, blue/white CTAs); verify on droplet after deploy |
| Home V2 `/home-v2` | `/home-v2/` | ✅ |
| Services `/services` | `/services/` | ✅ + all 7 service cards now link to real pages |
| Industrial Staffing | `/industrial-staffing/` | ✅ |
| Warehouse Staffing | `/warehouse-staffing/` | ✅ rebuilt 2026-07-05 (was MISSED in v1) |
| Manufacturing Staffing | `/manufacturing-staffing/` | ✅ rebuilt 2026-07-05 (was MISSED in v1) |
| Seasonal Staffing | `/seasonal-staffing/` | ✅ rebuilt 2026-07-05 (was MISSED in v1) |
| Greenhouse Staffing | `/greenhouse-staffing/` | ✅ rebuilt 2026-07-05 (was MISSED in v1) |
| Hospitality Staffing | `/hospitality-staffing/` | ✅ rebuilt 2026-07-05 (was MISSED in v1) |
| Temporary Staffing | `/temporary-staffing/` | ✅ rebuilt 2026-07-05 (was MISSED in v1) |
| About Us | `/about-us/` | ✅ |
| About Us (Job Seeker) | `/about-us-job-seeker/` | ✅ (canonical → /about-us) |
| Contact | `/contact/` | ✅ |
| Contact (Job Seeker) | `/contact-job-seeker/` | ✅ |
| Success Stories | `/success-stories/` | ✅ |
| Success Stories (JS) | `/success-stories-job-seekers/` | ✅ (canonical → /success-stories) |
| Home V1 `/apply-now` | `/apply-now/` | ✅ (jobs iframe dependency flagged, R3) |
| Landing Page `/learn-more` | `/learn-more/` | ✅ |
| Thank You | `/thank-you/` | ✅ noindex |
| Blog index `/blog` | `/blog/` | ✅ + 9 posts as summary/attribution pages |
| 404 | `/404.html` | ✅ noindex |

## 🚫 Deliberately excluded (with reasons)

| Webflow page | Reason |
|---|---|
| /old-home | Junk legacy page; noindexed on Webflow (Session 1–2 cleanup) |
| /search (Search Results) | Template feature; noindexed; no site search on static build |
| /401 (Password) | Webflow-only protected-page feature |
| /checkout, /paypal-checkout, /order-confirmation | Template e-commerce leftovers; never used |
| /extra-components/* (headers, footers, notification-bars) | BRIX template component library; noindexed |
| /utility-pages/* (start-here, styleguide, licenses, changelog) | BRIX template docs; noindexed |
| CMS templates: SKUs, Products, Categories, Authors, Blog Categories, Blog Posts, Job Categories, Companies, Jobs | All unpublished on Webflow (June session cleanup, DEC-007/DEC-009); no live URLs |

## Before ANY re-cutover (in order)

1. [ ] Homepage `/` rebuilt to visually match the live Webflow splash (screenshot compare)
2. [ ] Jake clicks through every ✅ page above at http://159.89.236.177 against the live site
3. [ ] Tammy sees the site and approves
4. [ ] Re-run this checklist top to bottom on cutover night
5. [ ] DNS flip → certbot → live HTTPS form test → monitor GSC for 48h
