#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
H='Host: test-s3.web0x05.hbtn'
URL='http://web0x05.hbtn/api/task1/'

echo "=== upload avec en-tetes complets ==="
curl -s -i -H "$H" -F 'file=@shell.php;type=image/png' "$URL"
echo
echo "=== meme chose, code + taille ==="
curl -s -o /tmp/resp.txt -w 'HTTP %{http_code} | size=%{size_download}\n' -H "$H" -F 'file=@shell.php;type=image/png' "$URL"
echo "--- corps ---"
cat /tmp/resp.txt ; echo
