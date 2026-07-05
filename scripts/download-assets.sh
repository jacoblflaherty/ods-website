#!/usr/bin/env bash
# Localize all Webflow-CDN assets. Portable to macOS bash 3.2.
# Run from the site/ directory:  bash scripts/download-assets.sh
set -euo pipefail

CDN1="https://cdn.prod.website-files.com/636d6d9c18e574a88037d5d7"
CDN2="https://cdn.prod.website-files.com/636d6d9c18e574abbf37d5e4"
mkdir -p assets/fonts assets/img

get() { # get <url> <localname>
  curl -fsSL "$1" -o "assets/img/$2" && echo "  ok  $2" || { echo "  FAIL $2"; exit 1; }
}

echo "==> Fonts"
curl -fsSL "$CDN1/636d6d9c18e574646c37d5fd_PlusJakartaDisplay-Regular.woff2" -o assets/fonts/PlusJakartaDisplay-Regular.woff2 && echo "  ok  Regular"
curl -fsSL "$CDN1/636d6d9c18e574af4337d5f6_PlusJakartaDisplay-Medium.woff2"  -o assets/fonts/PlusJakartaDisplay-Medium.woff2  && echo "  ok  Medium"
curl -fsSL "$CDN1/636d6d9c18e574180037d601_PlusJakartaDisplay-Bold.woff2"    -o assets/fonts/PlusJakartaDisplay-Bold.woff2    && echo "  ok  Bold"

echo "==> Site images"
get "$CDN1/636f4735f0039426413a06ec_ODS%20Revised%20LOgo%20Transparent.png" "logo.png"
get "$CDN1/636f47163b9c9d27d109bc9c_ODS%20LogoRevisionFInalwWhite.png" "logo-white.png"
get "$CDN1/63fac24c1ed05186cfc92402_supersmall.png" "favicon.png"
get "$CDN1/63fac25369b16e1990dc83dd_small.png" "touch-icon.png"
get "$CDN1/6370b6ce63d653b85a7f42f3_hero02.png" "hero-employer.png"
get "$CDN1/66240faff971285a2302bfad_ODS-Team-2024.png" "team-2024.png"
get "$CDN1/66240fdcb5257a2bc7b92040_ODS-TeamPhoto-2024V2.png" "team-2024-v2.png"
get "$CDN1/638ecc618cc13941a8b77760_odscon.jpeg" "ods-consulting.jpeg"
get "$CDN1/6372019b18cd9c794bb3bd42_odsphone.jpg" "ods-instagram-phone.jpg"
get "$CDN1/636f45ae4679d82ddc3137ca_ODS1.jpeg" "ods-office.jpeg"
get "$CDN1/6371578ea814281f38a8468d_DSC07798-min.JPG" "team-tammara.jpg"
get "$CDN1/637157ad019673af55c7bcd2_DSC07869-min.JPG" "team-andrea.jpg"
get "$CDN1/637157ae9b96f7ca7201a784_DSC07844-min.JPG" "team-chris.jpg"
get "$CDN1/6371f31b18cd9c69b2b2a4fd_7.svg" "avatar-7.svg"
get "$CDN1/6371f31af2d5ec209e506037_5.svg" "avatar-5.svg"
get "$CDN1/6371f31b0d7d5672c0a9e7df_6.svg" "avatar-6.svg"
get "$CDN1/6371f31b18cd9cd2f5b2a4fb_8.svg" "avatar-8.svg"
get "$CDN1/64113b4823a773165666e674_Untitled%20design%20(2).svg" "avatar-kevin.svg"
get "$CDN1/636d6d9c18e574aa9937d629_facebook.svg" "icon-facebook.svg"
get "$CDN1/636d6d9c18e574e33d37d62d_instagram.svg" "icon-instagram.svg"
get "$CDN1/638ec5378ce65f1cc3724aaa_lin.png" "icon-linkedin.png"
get "$CDN1/68ee95207f534aeb97fbd139_LinkedIn_logo_initials%20(2).png" "icon-linkedin-2.png"

echo "==> Blog hero images"
get "$CDN2/6425171c654f2aecc75d47c8_Screen%20Shot%202023-03-30%20at%2012.59.05%20AM.png" "blog-minimum-age.png"
get "$CDN2/642516cfaeb353e459abaee5_0399_638149182024275839.jpeg" "blog-pgwp.jpeg"
get "$CDN2/64251666aeb353ad35aba947_CNG_30319image_story.jpeg" "blog-passport-fines.jpeg"
get "$CDN2/6425161b384515de0a03506a_job_PxHere_450.jpeg" "blog-gig-workers.jpeg"
get "$CDN2/642515a9c7e0540185706017_Minimum-Wage-in-Ontario-is-Increasing-in-October-2022.webp" "blog-minimum-wage.webp"
get "$CDN2/63fab20a8bac0a01565408ce_forreign.jpeg" "blog-newcomers.jpeg"
get "$CDN2/6371d4c40d7d56dc97a7f76a_pexels-mikhail-nilov-7819723-min.jpg" "blog-precautions.jpg"
get "$CDN2/6371d5670ce0bd07a14d8f31_pexels-laura-tancredi-7078666-min.jpg" "blog-jobs-added.jpg"
get "$CDN2/6371d60263d653d625920935_pexels-pixabay-416405-min.jpg" "blog-jobs-forecasts.jpg"

echo ""
echo "All assets downloaded. Tell Claude: done"
