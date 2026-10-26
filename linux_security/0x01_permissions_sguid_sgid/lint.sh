#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
chmod +x [0-9]-*.sh
declare -A want=( [0-add_user.sh]=3 [1-add_group.sh]=4 [2-sudo_nopass.sh]=2 \
  [3-find_files.sh]=2 [4-find_suid.sh]=2 [5-find_sgid.sh]=2 [6-check_files.sh]=2 \
  [7-file_read.sh]=2 [8-change_user.sh]=2 [9-empty_file.sh]=2 )

echo "=== nb de lignes (attendu / reel) + 1ere ligne + syntaxe ==="
for f in [0-9]-*.sh; do
  n=$(wc -l < "$f")
  w=${want[$f]}
  first=$(head -1 "$f")
  bash -n "$f" 2>/dev/null && syn="syntaxe OK" || syn="SYNTAXE KO"
  [ "$first" = "#!/bin/bash" ] && sh="shebang OK" || sh="SHEBANG KO"
  mark="OK"; [ "$n" = "$w" ] || mark="!! LIGNES"
  printf '%-20s lignes %s/%s %-9s | %-11s | %s\n' "$f" "$n" "$w" "$mark" "$sh" "$syn"
done
echo
echo "=== recherche interdits (backtick, && , ||) ==="
grep -nE '`|&&|\|\|' [0-9]-*.sh && echo "!! INTERDIT TROUVE" || echo "OK: aucun backtick/&&/||"
echo
echo "=== exec bit ==="
ls -l [0-9]-*.sh | awk '{print $1, $NF}'
