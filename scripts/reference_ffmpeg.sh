#!/usr/bin/env bash
# SCRIPT DE RÉFÉRENCE — NE PAS EXÉCUTER TANT QUE LE PROJET EST EN PAUSE.
# Usage futur : reference_ffmpeg.sh INPUT OUTPUT_DIR SLUG vertical|horizontal [START] [DURATION]
set -euo pipefail

INPUT=${1:?source requise}
OUT=${2:?dossier de sortie requis}
SLUG=${3:?slug requis}
ORIENTATION=${4:?vertical ou horizontal}
START=${5:-}
DURATION=${6:-}
mkdir -p "$OUT"

TRIM=()
[[ -n "$START" ]] && TRIM+=( -ss "$START" )
[[ -n "$DURATION" ]] && TRIM+=( -t "$DURATION" )

if [[ "$ORIENTATION" == "vertical" ]]; then
  DESKTOP_SCALE="scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2"
  MOBILE_SCALE="scale=540:960:force_original_aspect_ratio=decrease,pad=540:960:(ow-iw)/2:(oh-ih)/2"
  SCRUB_SCALE="scale=432:768:force_original_aspect_ratio=decrease,pad=432:768:(ow-iw)/2:(oh-ih)/2"
else
  DESKTOP_SCALE="scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2"
  MOBILE_SCALE="scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2"
  SCRUB_SCALE="scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2"
fi

# Poster : première image du segment retenu.
ffmpeg -y "${TRIM[@]}" -i "$INPUT" -frames:v 1 -vf "$DESKTOP_SCALE" -q:v 3 "$OUT/${SLUG}-poster.jpg"

# Desktop H.264 — sans audio, chargement progressif.
ffmpeg -y "${TRIM[@]}" -i "$INPUT" -an -vf "$DESKTOP_SCALE" -r 25 \
  -c:v libx264 -preset slow -crf 27 -pix_fmt yuv420p -profile:v high -level 4.1 \
  -movflags +faststart -g 50 -keyint_min 25 -sc_threshold 0 "$OUT/${SLUG}-desktop.mp4"

# Desktop WebM VP9.
ffmpeg -y "${TRIM[@]}" -i "$INPUT" -an -vf "$DESKTOP_SCALE" -r 25 \
  -c:v libvpx-vp9 -crf 35 -b:v 0 -row-mt 1 -tile-columns 2 -threads 8 \
  "$OUT/${SLUG}-desktop.webm"

# Mobile H.264.
ffmpeg -y "${TRIM[@]}" -i "$INPUT" -an -vf "$MOBILE_SCALE" -r 25 \
  -c:v libx264 -preset slow -crf 29 -pix_fmt yuv420p -profile:v high -level 4.0 \
  -movflags +faststart -g 50 -keyint_min 25 -sc_threshold 0 "$OUT/${SLUG}-mobile.mp4"

# Mobile WebM VP9.
ffmpeg -y "${TRIM[@]}" -i "$INPUT" -an -vf "$MOBILE_SCALE" -r 25 \
  -c:v libvpx-vp9 -crf 37 -b:v 0 -row-mt 1 -tile-columns 2 -threads 8 \
  "$OUT/${SLUG}-mobile.webm"

# Scrubbing au scroll : H.264, GOP 3, sans audio. GOP 1 possible mais plus lourd.
ffmpeg -y "${TRIM[@]}" -i "$INPUT" -an -vf "$SCRUB_SCALE" -r 25 \
  -c:v libx264 -preset slow -crf 29 -pix_fmt yuv420p -profile:v high -level 4.0 \
  -movflags +faststart -g 3 -keyint_min 1 -sc_threshold 0 "$OUT/${SLUG}-scrub-gop3.mp4"

# Contrôle futur : aucune sortie ne doit dépasser 100 Mo ; objectif 10 Mo.
find "$OUT" -maxdepth 1 -type f -name "${SLUG}-*" -printf '%f\t%s octets\n' | sort
