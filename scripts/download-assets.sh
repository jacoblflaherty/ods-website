#!/usr/bin/env bash
# Localize all Webflow-CDN assets so the site has zero dependency on
# cdn.prod.website-files.com. Run from the site/ directory on your machine:
#   bash scripts/download-assets.sh
# Then run the URL rewrite it prints at the end, review, and commit.
set -euo pipefail

CDN="https://cdn.prod.website-files.com/636d6d9c18e574a88037d5d7"
mkdir -p assets/fonts assets/img

# Fonts
curl -fsSL "$CDN/636d6d9c18e574646c37d5fd_PlusJakartaDisplay-Regular.woff2" -o assets/fonts/PlusJakartaDisplay-Regular.woff2
curl -fsSL "$CDN/636d6d9c18e574af4337d5f6_PlusJakartaDisplay-Medium.woff2"  -o assets/fonts/PlusJakartaDisplay-Medium.woff2
curl -fsSL "$CDN/636d6d9c18e574180037d601_PlusJakartaDisplay-Bold.woff2"    -o assets/fonts/PlusJakartaDisplay-Bold.woff2

# Images referenced across pages (source filename -> local name)
declare -A IMG=(
  ["636f4735f0039426413a06ec_ODS%20Revised%20LOgo%20Transparent.png"]="logo.png"
  ["636f47163b9c9d27d109bc9c_ODS%20LogoRevisionFInalwWhite.png"]="logo-white.png"
  ["63fac24c1ed05186cfc92402_supersmall.png"]="favicon.png"
  ["63fac25369b16e1990dc83dd_small.png"]="touch-icon.png"
  ["6370b6ce63d653b85a7f42f3_hero02.png"]="hero-employer.png"
  ["66240faff971285a2302bfad_ODS-Team-2024.png"]="team-2024.png"
  ["66240fdcb5257a2bc7b92040_ODS-TeamPhoto-2024V2.png"]="team-2024-v2.png"
  ["638ecc618cc13941a8b77760_odscon.jpeg"]="ods-consulting.jpeg"
  ["6372019b18cd9c794bb3bd42_odsphone.jpg"]="ods-instagram-phone.jpg"
  ["636f45ae4679d82ddc3137ca_ODS1.jpeg"]="ods-office.jpeg"
  ["6371578ea814281f38a8468d_DSC07798-min.JPG"]="team-tammara.jpg"
  ["637157ad019673af55c7bcd2_DSC07869-min.JPG"]="team-andrea.jpg"
  ["637157ae9b96f7ca7201a784_DSC07844-min.JPG"]="team-chris.jpg"
  ["6371f31b18cd9c69b2b2a4fd_7.svg"]="avatar-7.svg"
  ["6371f31af2d5ec209e506037_5.svg"]="avatar-5.svg"
  ["6371f31b0d7d5672c0a9e7df_6.svg"]="avatar-6.svg"
  ["6371f31b18cd9cd2f5b2a4fb_8.svg"]="avatar-8.svg"
  ["64113b4823a773165666e674_Untitled%20design%20(2).svg"]="avatar-kevin.svg"
  ["636d6d9c18e574aa9937d629_facebook.svg"]="icon-facebook.svg"
  ["636d6d9c18e574e33d37d62d_instagram.svg"]="icon-instagram.svg"
  ["638ec5378ce65f1cc3724aaa_lin.png"]="icon-linkedin.png"
  ["68ee95207f534aeb97fbd139_LinkedIn_logo_initials%20(2).png"]="icon-linkedin-2.png"
)
for src in "${!IMG[@]}"; do
  curl -fsSL "$CDN/$src" -o "assets/img/${IMG[$src]}"
  echo "  ${IMG[$src]}"
done

echo ""
echo "Done. Next step — rewrite CDN URLs to local paths in all HTML/CSS:"
echo "  (Ask Claude to run the rewrite, or do a find-and-replace of each CDN URL to /assets/img/<name>.)"
