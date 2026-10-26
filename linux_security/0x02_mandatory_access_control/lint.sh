#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
chmod +x [0-9]-*.sh
echo "=== lignes + 1ere ligne + syntaxe + contenu ==="
for f in [0-9]-*.sh; do
  n=$(wc -l < "$f")
  first=$(head -1 "$f")
  bash -n "$f" 2>/dev/null && syn="syntaxe OK" || syn="SYNTAXE KO"
  [ "$first" = "#!/bin/bash" ] && sh="shebang OK" || sh="SHEBANG KO"
  printf '%-22s %s lignes | %-11s | %-11s | %s\n' "$f" "$n" "$sh" "$syn" "$(sed -n 2p "$f")"
done
echo
echo "=== interdits (backtick, && , ||) ==="
grep -nE '`|&&|\|\|' [0-9]-*.sh && echo "!! INTERDIT" || echo "OK: aucun"
