#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
H='Host: test-s3.web0x05.hbtn'
B='http://web0x05.hbtn'

for n in 2 3 4; do
  echo "############ TASK $n ############"
  echo "--- page /task$n (headers) ---"
  curl -s -i -H "$H" "$B/task$n" | sed -n '1,15p'
  echo
  echo "--- POST vide /api/task$n/ (champ attendu) ---"
  curl -s -i -H "$H" -X POST "$B/api/task$n/" | sed -n '1,20p'
  echo
done
