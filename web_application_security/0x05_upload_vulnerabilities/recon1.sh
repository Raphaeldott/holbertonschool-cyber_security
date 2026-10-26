#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
H='Host: test-s3.web0x05.hbtn'
BASE='http://web0x05.hbtn'

echo "=== statut endpoints ==="
for p in /task1 /api/task1/ /static/index-DYK-Cu5G.js; do
  code=$(curl -s -o /dev/null -w '%{http_code}' -H "$H" "$BASE$p")
  echo "$p -> $code"
done

echo
echo "=== download JS ==="
curl -s -H "$H" "$BASE/static/index-DYK-Cu5G.js" -o app.js
wc -c app.js

echo
echo "=== routes /api ==="
grep -oiE '/api/[a-z0-9/_-]+' app.js | sort -u

echo
echo "=== FormData.append fields ==="
grep -oiE "append\(['\"][^'\"]+['\"]" app.js | sort -u

echo
echo "=== filtres extensions/mime ==="
grep -oiE "\.(php|phtml|jpg|jpeg|png|gif|txt|svg)|allowed|accept|mimetype|extension|image/[a-z]+" app.js | sort -u
