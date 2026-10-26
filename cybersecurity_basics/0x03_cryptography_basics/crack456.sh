#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
RK=/usr/share/wordlists/rockyou.txt

echo "############ TASK 4 : hashes 32 hex -> MD5 (-m 0) ############"
hashcat -m 0 -a 0 hash.txt "$RK" --quiet 2>/dev/null
echo "   --show :"; hashcat -m 0 hash.txt --show 2>/dev/null

echo
echo "############ TASK 5 : NT (-m 1000) ############"
hashcat -m 1000 -a 0 hash_nt.txt "$RK" --quiet 2>/dev/null
echo "   --show :"; hashcat -m 1000 hash_nt.txt --show 2>/dev/null

echo
echo "############ TASK 6 : SHA256 (-m 1400) ############"
hashcat -m 1400 -a 0 crack.txt "$RK" --quiet 2>/dev/null
echo "   --show :"; hashcat -m 1400 crack.txt --show 2>/dev/null
