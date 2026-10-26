#!/bin/bash
# Casse un hash MD5 de $1 avec hashcat en attaque par combinaison (-a 1)
# en combinant wordlist1.txt et wordlist2.txt.
hashcat -m 0 -a 1 "$1" wordlist1.txt wordlist2.txt
hashcat -m 0 "$1" --show | awk -F: 'NF>1 {print $NF}' > 9-password.txt
cat 9-password.txt
