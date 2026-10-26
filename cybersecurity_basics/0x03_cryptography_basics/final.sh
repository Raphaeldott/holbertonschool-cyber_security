#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
chmod +x *.sh
echo "=== scripts livrables ==="
ls -1 [0-9]-*.sh
echo
echo "=== fichiers password / hash livrables ==="
for f in 0_hash.txt 1_hash.txt 2_hash.txt 3_hash.txt 4-password.txt 5-password.txt 6-password.txt 7-password.txt 9-password.txt; do
  if [ -f "$f" ]; then printf '%-16s ' "$f"; tr '\n' ' ' < "$f"; echo; fi
done
