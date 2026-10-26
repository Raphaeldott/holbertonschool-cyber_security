#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
H='Host: test-s3.web0x05.hbtn'
URL='http://web0x05.hbtn/api/task1/'

echo "=== POST vide (voir message d'erreur / champ attendu) ==="
curl -s -H "$H" -X POST "$URL" ; echo

echo
echo "=== contexte 'append' dans le JS (minifie) ==="
grep -oE '\.append\([^)]{0,40}' app.js | head
grep -oE 'FormData[^;]{0,80}' app.js | head
grep -oiE '(file|image|upload|document|photo)[A-Za-z]{0,10}' app.js | sort -u | head -30
