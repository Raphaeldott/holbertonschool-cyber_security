#!/usr/bin/env bash
echo "SHA1  sans nl : $(printf '%s' Holberton | sha1sum | awk '{print $1}')  attendu 808f94d2847fb381839b4bbbd7cdf30804fd47ac"
echo "SHA1  avec nl : $(echo Holberton | sha1sum | awk '{print $1}')"
echo "SHA256 sans nl: $(printf '%s' Holberton | sha256sum | awk '{print $1}')  attendu 77c4925c01e8d9f79c8a6a61685c6b3182be10f2fa553de915f3733ee19c0204"
echo "SHA256 avec nl: $(echo Holberton | sha256sum | awk '{print $1}')"
echo "MD5    sans nl: $(printf '%s' Holberton | md5sum | awk '{print $1}')  attendu f3b21c0205fba4fc7e6cb96ae6edc950"
echo "MD5    avec nl: $(echo Holberton | md5sum | awk '{print $1}')"
echo "--- apt dispo pour john/hashcat/rockyou ? ---"
apt-cache policy john hashcat wordlists 2>/dev/null | grep -E 'john|hashcat|wordlists|Candidate' | head
