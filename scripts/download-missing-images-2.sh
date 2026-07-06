#!/bin/bash
# Round 2: CSS background images the element audit missed (backgrounds aren't <img> tags).
# Source: live stylesheet ondemand-staffing.webflow.shared.972782d8b.css
set -e
CDN="https://cdn.prod.website-files.com/636d6d9c18e574a88037d5d7"
DIR="$(cd "$(dirname "$0")/.." && pwd)/assets/img"
cd "$DIR"
get() { echo "-> $2"; curl -sfL "$1" -o "$2"; }

get "$CDN/636f48851d81f496d44d94f0_WORK.jpeg" "work-bg.jpeg"                # blue wallpaper: office building behind team photos
get "$CDN/6370b6ce63d653b85a7f42f3_hero02.png" "hero-bg.png"                # home-v2 hero background (right side)
get "$CDN/636d6d9c18e574046e37d61f_banner-bg.svg" "banner-bg.svg"           # newsletter banner decoration
get "$CDN/636d6d9c18e5741eb837d669_circle-background-home-2-jobs-template.svg" "hero-circles-bg.svg"  # hero-v2 circle overlay
get "$CDN/637162414679d8241b51af30_IMG_6803.jpg" "spark-hero-bg.jpg"        # dark hero background (contact)

echo "Done."
