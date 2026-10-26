#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
chmod +x [0-9]-*.sh
echo "=== wc -l (doit etre 2 partout) ==="
wc -l [0-9]-*.sh
echo
echo "=== recherche caracteres interdits ; && || backtick ==="
grep -nE ';|&&|\|\||`' [0-9]-*.sh && echo "!! INTERDIT TROUVE" || echo "OK: aucun interdit"
echo
echo "=== premiere ligne de chaque script ==="
for f in [0-9]-*.sh; do printf '%-26s ' "$f"; head -1 "$f"; done
echo
echo "=== test hash 0-3 ==="
./0-sha1.sh "Holberton";   echo "0: $(cat 0_hash.txt)  (att 808f94d2847fb381839b4bbbd7cdf30804fd47ac)"
./1-sha256.sh "Holberton"; echo "1: $(cat 1_hash.txt)  (att 77c4925c01e8d9f79c8a6a61685c6b3182be10f2fa553de915f3733ee19c0204)"
./2-md5.sh "Holberton";    echo "2: $(cat 2_hash.txt)  (att f3b21c0205fba4fc7e6cb96ae6edc950)"
./3-password_hash.sh "maroua@123"; echo "3: $(cat 3_hash.txt)"
