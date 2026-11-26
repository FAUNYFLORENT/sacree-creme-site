#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; SRC="$ROOT/source-videos"; OUT="$ROOT/public/media"
mkdir -p "$OUT/coffee-shop" "$OUT/signature" "$OUT/caen" "$OUT/posters"

run_missing(){ local out="$1"; shift; if [[ -s "$out" ]]; then echo "skip $(basename "$out")"; else rm -f "$out"; "$@"; echo "done $(basename "$out")"; fi; }
encode(){
 local input="$1" dir="$2" slug="$3" orient="$4" start="${5:-}" dur="${6:-}"; local trim=(); [[ -n "$start" ]]&&trim+=(-ss "$start"); [[ -n "$dur" ]]&&trim+=(-t "$dur");
 local ds ms ss; if [[ "$orient" == vertical ]]; then ds='scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2'; ms='scale=540:960:force_original_aspect_ratio=decrease,pad=540:960:(ow-iw)/2:(oh-ih)/2'; ss='scale=432:768:force_original_aspect_ratio=decrease,pad=432:768:(ow-iw)/2:(oh-ih)/2'; else ds='scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2'; ms='scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2'; ss="$ms"; fi
 run_missing "$OUT/posters/$slug.jpg" ffmpeg -y -v error "${trim[@]}" -i "$input" -an -frames:v 1 -vf "$ds" -q:v 3 "$OUT/posters/$slug.jpg"
 run_missing "$OUT/$dir/$slug-desktop.mp4" ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$ds" -r 25 -c:v libx264 -preset medium -crf 29 -pix_fmt yuv420p -movflags +faststart -g 50 -keyint_min 25 -sc_threshold 0 "$OUT/$dir/$slug-desktop.mp4"
 run_missing "$OUT/$dir/$slug-desktop.webm" ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$ds" -r 25 -c:v libvpx-vp9 -deadline good -cpu-used 5 -crf 38 -b:v 0 -row-mt 1 -tile-columns 2 -threads 8 "$OUT/$dir/$slug-desktop.webm"
 run_missing "$OUT/$dir/$slug-mobile.mp4" ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$ms" -r 25 -c:v libx264 -preset medium -crf 31 -pix_fmt yuv420p -movflags +faststart -g 50 -keyint_min 25 -sc_threshold 0 "$OUT/$dir/$slug-mobile.mp4"
 run_missing "$OUT/$dir/$slug-mobile.webm" ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$ms" -r 25 -c:v libvpx-vp9 -deadline good -cpu-used 5 -crf 40 -b:v 0 -row-mt 1 -tile-columns 2 -threads 8 "$OUT/$dir/$slug-mobile.webm"
 run_missing "$OUT/$dir/$slug-scrub-gop3.mp4" ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$ss" -r 25 -c:v libx264 -preset medium -crf 32 -pix_fmt yuv420p -movflags +faststart -g 3 -keyint_min 1 -sc_threshold 0 "$OUT/$dir/$slug-scrub-gop3.mp4"
}

case "${1:-all}" in
  signature)
    encode "$SRC/plan_vertical_chocolat_chaud.mov" coffee-shop chocolat-chaud vertical
    encode "$SRC/plan_vertical_glace_vanille.mov" signature prelevement-glace-vanille vertical
    encode "$SRC/plan_vertical_passage_glace_kasha_1.mov" signature remise-pot-client vertical
    ;;
  caen)
    encode "$SRC/montage_3_site_horizontal.mov" caen caen-facade horizontal 12.16 3.00
    encode "$SRC/montage_3_site_horizontal.mov" caen caen-interieur horizontal 15.36 6.40
    encode "$SRC/montage_3_site_horizontal.mov" caen caen-produits horizontal 27.40 4.30
    encode "$SRC/montage_3_site_horizontal.mov" caen caen-ambiance horizontal 31.88 4.20
    ;;
  *) "$0" signature; "$0" caen;;
esac
