# OnDemand Staffing — Static Site

Static HTML/CSS/JS rebuild of [ondemandstaffing.ca](https://www.ondemandstaffing.ca) (previously Webflow). Zero frameworks, zero build step. Target host: DigitalOcean droplet (nginx).

## Run locally

```bash
cd site
python3 -m http.server 8080
# open http://localhost:8080
```

A server is required (pages use absolute paths like `/css/main.css`).

## Structure

Same URL slugs as the live site, preserved for SEO (each page is `<slug>/index.html`). `404.html` at root (map with nginx `error_page 404 /404.html;`). Design tokens: `BRANDING.md`. Third-party script audit: `docs/API-NOTES.md`.

## Status / launch blockers

- **Forms are UI-only.** Not wired to any backend; the live Webflow site remains the real lead pipeline. Before cutover: build submission endpoint (POST), add Cloudflare Turnstile, route to info@/work@ inboxes. PIPEDA note: old site submitted via GET — rebuild is POST-ready.
- **Images/fonts still load from the Webflow CDN.** Run `scripts/download-assets.sh` then rewrite URLs to `/assets/…` before launch (blocker if Webflow subscription is ever cancelled).
- **Jobs board** on /apply-now is an iframe to a WRPD WordPress staging domain. Decision needed (direct Bullhorn embed / production domain / API rebuild).
- **Blog** not migrated; nav links point at the live Webflow blog.
- Canonical pairs implemented: `about-us-job-seeker` → `about-us`, `success-stories-job-seekers` → `success-stories` (duplicate content). Confirm before launch.
- Street addresses missing from JSON-LD LocalBusiness schema (only city-level). Get from Tammy.

## Improvements over the Webflow site (from the standing audit)

tel:/mailto: links sitewide (were dead `#`), amber buttons use navy text (WCAG AA fix), eager + `fetchpriority=high` LCP images, dynamic copyright year, no jQuery/Webflow runtime (~350KB JS removed), semantic HTML + real alt text, EmploymentAgency JSON-LD, en-CA lang.

## Deploy (later)

nginx on the droplet, docroot = this folder. Needed config: `error_page 404 /404.html;`, gzip/brotli on, far-future cache headers for `/assets`, `/css`, `/js`.
