#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/source-videos"
OUT="$ROOT/public/media"
REPORT="$ROOT/reports/media-manifest.csv"
mkdir -p "$OUT/architecture" "$OUT/signature" "$OUT/coffee-shop" "$OUT/caen" "$OUT/posters"

printf 'source,asset,variant,codec,width,height,duration_seconds,size_bytes,usage\n' > "$REPORT"

probe_row() {
  local source="$1" asset="$2" variant="$3" usage="$4" file="$5"
  ffprobe -v error -show_entries format=duration,size:stream=codec_name,width,height -select_streams v:0 -of csv=p=0 "$file" | \
  awk -F',' -v s="$source" -v a="$asset" -v v="$variant" -v u="$usage" '{printf "\"%s\",\"%s\",\"%s\",%s,%s,%s,%.3f,%s,\"%s\"\n",s,a,v,$1,$2,$3,$4,$5,u}' >> "$REPORT"
}

encode_set() {
  local input="$1" dir="$2" slug="$3" orientation="$4" usage="$5"
  local seek="${6:-}" duration="${7:-}"
  local trim=()
  [[ -n "$seek" ]] && trim+=( -ss "$seek" )
  [[ -n "$duration" ]] && trim+=( -t "$duration" )
  mkdir -p "$OUT/$dir"

  local dscale mscale sscale
  if [[ "$orientation" == "vertical" ]]; then
    dscale="scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2"
    mscale="scale=540:960:force_original_aspect_ratio=decrease,pad=540:960:(ow-iw)/2:(oh-ih)/2"
    sscale="scale=432:768:force_original_aspect_ratio=decrease,pad=432:768:(ow-iw)/2:(oh-ih)/2"
  else
    dscale="scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2"
    mscale="scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2"
    sscale="scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2"
  fi

  ffmpeg -y -v error "${trim[@]}" -i "$input" -an -frames:v 1 -vf "$dscale" -q:v 3 "$OUT/posters/${slug}.jpg"
  ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$dscale" -r 25 -c:v libx264 -preset slow -crf 29 -pix_fmt yuv420p -profile:v high -movflags +faststart -g 50 -keyint_min 25 -sc_threshold 0 "$OUT/$dir/${slug}-desktop.mp4"
  ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$dscale" -r 25 -c:v libvpx-vp9 -deadline good -cpu-used 3 -crf 38 -b:v 0 -row-mt 1 -tile-columns 2 -threads 8 "$OUT/$dir/${slug}-desktop.webm"
  ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$mscale" -r 25 -c:v libx264 -preset slow -crf 31 -pix_fmt yuv420p -profile:v high -movflags +faststart -g 50 -keyint_min 25 -sc_threshold 0 "$OUT/$dir/${slug}-mobile.mp4"
  ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$mscale" -r 25 -c:v libvpx-vp9 -deadline good -cpu-used 3 -crf 40 -b:v 0 -row-mt 1 -tile-columns 2 -threads 8 "$OUT/$dir/${slug}-mobile.webm"
  ffmpeg -y -v error "${trim[@]}" -i "$input" -an -vf "$sscale" -r 25 -c:v libx264 -preset slow -crf 32 -pix_fmt yuv420p -profile:v high -movflags +faststart -g 3 -keyint_min 1 -sc_threshold 0 "$OUT/$dir/${slug}-scrub-gop3.mp4"

  probe_row "$(basename "$input")" "$slug" "desktop-mp4" "$usage" "$OUT/$dir/${slug}-desktop.mp4"
  probe_row "$(basename "$input")" "$slug" "desktop-webm" "$usage" "$OUT/$dir/${slug}-desktop.webm"
  probe_row "$(basename "$input")" "$slug" "mobile-mp4" "$usage" "$OUT/$dir/${slug}-mobile.mp4"
  probe_row "$(basename "$input")" "$slug" "mobile-webm" "$usage" "$OUT/$dir/${slug}-mobile.webm"
  probe_row "$(basename "$input")" "$slug" "scrub-gop3-mp4" "$usage" "$OUT/$dir/${slug}-scrub-gop3.mp4"
}

# Séquence architecturale native confirmée : archi_1 → archi_9 → logo extérieur.
for i in {1..9}; do
  encode_set "$SRC/plan_horizontal_concept_archi_${i}.mov" architecture "archi-${i}" horizontal "Séquence architecturale native — plan ${i}/9"
done
encode_set "$SRC/plan_horizontal_concept_archi_logo_exterieur.mov" architecture "archi-logo-exterieur" horizontal "Focus enseigne extérieure avec ciel après archi_9"

# Plans signature / arbitrage éditorial.
encode_set "$SRC/plan_horizontal_pluie_sucre_glace.mov" signature "pluie-sucre-glace" horizontal "Plan signature — position à arbitrer"
encode_set "$SRC/plan_vertical_concept_archi_3.mov" signature "miroir-logo-transition" vertical "Transition verticale miroir/logo — insertion à arbitrer"
encode_set "$SRC/plan_vertical_chocolat_chaud.mov" coffee-shop "chocolat-chaud" vertical "Fond animé Coffee Shop et lien Produit du moment"
encode_set "$SRC/plan_vertical_glace_vanille.mov" signature "prelevement-glace-vanille" vertical "Candidat ouverture — prélèvement à la cuillère, à valider"
encode_set "$SRC/plan_vertical_passage_glace_kasha_1.mov" signature "remise-pot-client" vertical "Candidat ouverture — remise du pot, à valider"

# Montage 3 sites : extraits préparatoires Caen, timecodes à faire valider.
encode_set "$SRC/montage_3_site_horizontal.mov" caen "caen-facade" horizontal "Caen — façade large" "12.16" "3.00"
encode_set "$SRC/montage_3_site_horizontal.mov" caen "caen-interieur" horizontal "Caen — intérieur et comptoir" "15.36" "6.40"
encode_set "$SRC/montage_3_site_horizontal.mov" caen "caen-produits" horizontal "Caen — bacs et textures de glace" "27.40" "4.30"
encode_set "$SRC/montage_3_site_horizontal.mov" caen "caen-ambiance" horizontal "Caen — salle et expérience" "31.88" "4.20"

# Garde-fou GitHub Pages.
python3 - "$OUT" "$REPORT" <<'PY'
import os,sys,csv
root,report=sys.argv[1:]
files=[]
for dp,_,names in os.walk(root):
    for n in names:
        p=os.path.join(dp,n); size=os.path.getsize(p)
        files.append((os.path.relpath(p,root),size))
over=[x for x in files if x[1]>=100_000_000]
large=[x for x in files if x[1]>=10_000_000]
with open(os.path.join(os.path.dirname(report),'size-audit.txt'),'w') as f:
    f.write(f"Fichiers générés: {len(files)}\n")
    f.write(f">=10 Mo: {len(large)}\n")
    for p,s in large:f.write(f"ATTENTION {s/1e6:.2f} MB\t{p}\n")
    f.write(f">=100 Mo: {len(over)}\n")
if over:
    raise SystemExit('Échec: un fichier dépasse la limite GitHub de 100 Mo')
PY

echo "Media build complete: $REPORT"
