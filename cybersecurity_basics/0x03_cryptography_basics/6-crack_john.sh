#!/bin/bash
# Casse le hash SHA-256 de $1 (crack.txt) avec John the Ripper (RockYou).
WORDLIST=/usr/share/wordlists/rockyou.txt
john --wordlist="$WORDLIST" --format=Raw-SHA256 "$1"
john --show --format=Raw-SHA256 "$1" | awk -F: 'NF>1 {print $2}' > 6-password.txt
cat 6-password.txt
