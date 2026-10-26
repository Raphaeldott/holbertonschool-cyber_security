#!/bin/bash
# Casse un hash MD5 de $1 avec hashcat en attaque directe (straight, -a 0) sur RockYou.
WORDLIST=/usr/share/wordlists/rockyou.txt
hashcat -m 0 -a 0 "$1" "$WORDLIST"
hashcat -m 0 "$1" --show | awk -F: 'NF>1 {print $NF}' > 7-password.txt
cat 7-password.txt
