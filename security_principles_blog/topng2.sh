#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
declare -A dim=( [01-defense-in-depth]="760 680" [02-least-privilege]="860 520" \
  [03-separation-of-duties]="880 420" [04-secure-by-design]="760 620" \
  [05-security-obscurity]="760 540" [06-synthesis]="780 640" )

CHROME=chromium-browser
for name in "${!dim[@]}"; do
  read -r w h <<< "${dim[$name]}"
  # wrapper HTML qui fixe la taille de l'image (aspect = viewBox)
  cat > "/tmp/wrap.html" <<EOF
<!doctype html><html><body style="margin:0;background:#fff">
<img src="file://$PWD/$name.svg" width="$w" height="$h">
</body></html>
EOF
  "$CHROME" --headless --no-sandbox --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=2 --window-size="$w,$h" \
    --screenshot="$PWD/$name.png" "file:///tmp/wrap.html" >/dev/null 2>&1
  if [ -s "$name.png" ]; then echo "ok  $name.png"; else echo "KO  $name.png"; fi
done
echo
ls -la *.png
