#!/bin/bash
# Casse les hash MD5 de $1 avec John the Ripper en mode wordlist (RockYou).
WORDLIST=/usr/share/wordlists/rockyou.txt
john --wordlist="$WORDLIST" --format=Raw-MD5 "$1"
john --show --format=Raw-MD5 "$1" | awk -F: 'NF>1 {print $2}' > 4-password.txt
cat 4-password.txt
