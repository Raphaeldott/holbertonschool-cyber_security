#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
echo "=== convertisseurs dispo ==="
for t in rsvg-convert inkscape convert chromium chromium-browser dwebp; do
  printf '%-18s ' "$t"; command -v "$t" || echo ABSENT
done
echo
echo "=== conversion SVG -> PNG (si rsvg-convert ou convert dispo) ==="
for f in 0*.svg; do
  out="${f%.svg}.png"
  if command -v rsvg-convert >/dev/null; then
    rsvg-convert -w 1200 "$f" -o "$out" && echo "ok (rsvg) $out"
  elif command -v convert >/dev/null; then
    convert -density 150 -background white "$f" "$out" && echo "ok (convert) $out"
  else
    echo "pas de convertisseur"
    break
  fi
done
ls -la *.png 2>/dev/null
