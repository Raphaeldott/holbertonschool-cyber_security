#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
chmod +x *.sh
echo "=== Task 0 : SHA1 Holberton ==="
./0-sha1.sh "Holberton"; echo -n "0_hash.txt : "; cat 0_hash.txt
echo "   attendu : 808f94d2847fb381839b4bbbd7cdf30804fd47ac"
echo
echo "=== Task 1 : SHA256 Holberton ==="
./1-sha256.sh "Holberton"; echo -n "1_hash.txt : "; cat 1_hash.txt
echo "   attendu : 77c4925c01e8d9f79c8a6a61685c6b3182be10f2fa553de915f3733ee19c0204"
echo
echo "=== Task 2 : MD5 Holberton ==="
./2-md5.sh "Holberton"; echo -n "2_hash.txt : "; cat 2_hash.txt
echo "   attendu : f3b21c0205fba4fc7e6cb96ae6edc950"
echo
echo "=== Task 3 : OpenSSL salt + SHA512 ==="
./3-password_hash.sh "maroua@123"
echo "(le hash change a chaque execution car le sel est aleatoire -> format SHA512(stdin)= ...)"
