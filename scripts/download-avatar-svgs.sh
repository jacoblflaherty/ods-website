#!/bin/bash
# Re-fetch original template avatar SVGs for proper rasterization (first attempt dropped embedded images).
set -e
CDN="https://cdn.prod.website-files.com/636d6d9c18e574a88037d5d7"
DIR="$(cd "$(dirname "$0")/.." && pwd)/assets/img/tmp-svg"
mkdir -p "$DIR"; cd "$DIR"
get() { echo "-> $2"; curl -sfL "$1" -o "$2"; }
get "$CDN/6371f31af2d5ec209e506037_5.svg" "avatar-5.svg"
get "$CDN/6371f31b0d7d5672c0a9e7df_6.svg" "avatar-6.svg"
get "$CDN/6371f31b18cd9c69b2b2a4fd_7.svg" "avatar-7.svg"
get "$CDN/6371f31b18cd9cd2f5b2a4fb_8.svg" "avatar-8.svg"
get "$CDN/64113b4823a773165666e674_Untitled%20design%20(2).svg" "avatar-kevin.svg"
echo "Done."
