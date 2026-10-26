#!/bin/bash
# Casse un hash NT/NTLM (Windows) de $1 avec John the Ripper (format nt, RockYou).
WORDLIST=/usr/share/wordlists/rockyou.txt
john --wordlist="$WORDLIST" --format=nt "$1"
john --show --format=nt "$1" | awk -F: 'NF>1 {print $2}' > 5-password.txt
cat 5-password.txt
