#!/bin/bash
# Downloads the images the 2026-07-05 API audit found missing from the static build.
# Source of truth: Webflow Assets API (site 636d6d9c18e574a88037d5d7).
set -e
CDN="https://cdn.prod.website-files.com/636d6d9c18e574a88037d5d7"
DIR="$(cd "$(dirname "$0")/.." && pwd)/assets/img"
cd "$DIR"

get() { echo "-> $2"; curl -sfL "$1" -o "$2"; }

# Real photos
get "$CDN/638ed1d2af44d494c812afee_Screen%20Shot%202022-12-06%20at%2012.17.56%20AM-min.png" "ods-team-office.png"
get "$CDN/63720422131625f4d512c640_Untitled%20design%20(80).png" "ods-team-collage.png"
get "$CDN/6624122c5ec71461277bc474_325739105_879749783480235_5655422989079948945_n.jpg" "ods-team-fb.jpg"
get "$CDN/6371f82bf2d5ec21b150d401_Untitled%20design%20(9).png" "success-photo-1.png"
get "$CDN/6371f98225366f9d91f528dd_Untitled%20design%20(10).png" "success-photo-2.png"

# Decorations
get "$CDN/6371f57c0196732715d24d12_noun_Quote_89670.svg" "icon-quote.svg"
get "$CDN/636d6d9c18e574a40737d66f_circle-background-01-home-jobs-template.svg" "circle-01.svg"
get "$CDN/636d6d9c18e574f92d37d66c_circle-background-02-home-jobs-template.svg" "circle-02.svg"
get "$CDN/636d6d9c18e5741ccb37d66e_circle-background-03-home-jobs-template.svg" "circle-03.svg"
get "$CDN/636d6d9c18e574d01b37d66d_circle-background-04-home-jobs-template.svg" "circle-04.svg"
get "$CDN/636d6d9c18e5746ebd37d670_circle-background-05-home-jobs-template.svg" "circle-05.svg"
get "$CDN/636d6d9c18e574b88637d671_circle-background-06-home-jobs-template.svg" "circle-06.svg"

echo "Done. $(ls -1 ods-team-*.* success-photo-*.png icon-quote.svg circle-0*.svg 2>/dev/null | wc -l | tr -d ' ') files downloaded."
