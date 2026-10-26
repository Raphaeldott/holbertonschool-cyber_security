#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
echo "=== pwd ==="; pwd
echo "=== contenu du dossier ==="; ls -la
echo
echo "=== outils ==="
for t in sha1sum sha256sum md5sum openssl john hashcat; do
  printf '%-10s ' "$t"; command -v "$t" || echo "ABSENT"
done
echo
echo "=== wordlist rockyou ==="
ls -la /usr/share/wordlists/rockyou.txt 2>/dev/null || echo "pas dans /usr/share/wordlists"
find / -name 'rockyou.txt*' 2>/dev/null | head
echo
echo "=== vecteurs de test 'Holberton' ==="
echo "SHA1  sans newline : $(printf '%s' Holberton | sha1sum | awk '{print $1}')  (attendu 808f94d2847fb381839b4bbbd7cdf30804fd47ac)"
echo "SHA1  avec newline : $(echo Holberton | sha1sum | awk '{print $1}')"
echo "SHA256 sans newline: $(printf '%s' Holberton | sha256sum | awk '{print $1}')  (attendu 77c4925c01e8d9f79c8a6a61685c6b3182be10f2fa553de915f3733ee19c0204)"
echo "SHA256 avec newline: $(echo Holberton | sha256sum | awk '{print $1}')"
echo "MD5    sans newline: $(printf '%s' Holberton | md5sum | awk '{print $1}')  (attendu f3b21c0205fba4fc7e6cb96ae6edc950)"
echo "MD5    avec newline: $(echo Holberton | md5sum | awk '{print $1}')"
