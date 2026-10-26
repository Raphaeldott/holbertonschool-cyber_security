#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
chmod +x [0-9]-*.sh
echo "=== lignes + shebang + syntaxe ==="
for f in [0-9]-*.sh; do
  n=$(wc -l < "$f")
  first=$(head -1 "$f")
  bash -n "$f" 2>/dev/null && syn="syntaxe OK" || syn="SYNTAXE KO"
  [ "$first" = "#!/bin/bash" ] && sh="shebang OK" || sh="SHEBANG KO"
  note=""
  [ "$f" = "9-firewall.sh" ] && { [ "$n" = "3" ] && note="(task9: 3 lignes OK)" || note="(task9: !! doit faire 3)"; }
  printf '%-18s %s lignes | %-11s | %-11s %s\n' "$f" "$n" "$sh" "$syn" "$note"
done
echo
echo "=== interdits (backtick, && , ||) ==="
grep -nE '`|&&|\|\|' [0-9]-*.sh && echo "!! INTERDIT" || echo "OK: aucun"
