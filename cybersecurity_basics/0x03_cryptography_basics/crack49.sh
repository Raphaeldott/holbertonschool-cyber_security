#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
export PATH=$PATH:/usr/sbin:/sbin
RK=/usr/share/wordlists/rockyou.txt

echo "=== verif outils ==="
command -v john; command -v hashcat; ls -la "$RK" | awk '{print $5, $9}'
echo

# fichiers d'entree depuis les exemples de l'enonce
printf '42f749ade7f9e195bf475f37a44cafcb\nfc5e038d38a57032085441e7fe7010b0\n18f1072de45420e57fd22ee5bd59df9e\n' > hash.txt
printf '895F465356A0403458759A6B104B7242\n' > hash_nt.txt
printf 'aee408847d35e44e99430f0979c3357b85fe8dbb4535a494301198adbee85f27\n' > crack.txt
printf '5f4dcc3b5aa765d61d8327deb882cf99\n' > hash_md5.txt
printf '5ad8699d82cd039cab4ed739590969b9\n' > hash_comb.txt
printf 'pass\n123\nhello\n' > wordlist1.txt
printf 'word\nworld\n000\n' > wordlist2.txt

echo "############ TASK 4 : john wordlist (detection format) ############"
for fmt in Raw-SHA256 Raw-MD5; do
  echo "--- essai --format=$fmt ---"
  john --wordlist="$RK" --format="$fmt" hash.txt 2>&1 | grep -iE 'loaded|cracked|No password|Warning: only' | head -3
  john --show --format="$fmt" hash.txt 2>&1 | grep -vE '^$|password hash'
done

echo
echo "############ TASK 5 : john NT ############"
john --wordlist="$RK" --format=nt hash_nt.txt 2>&1 | grep -iE 'loaded|No password' | head -2
john --show --format=nt hash_nt.txt

echo
echo "############ TASK 6 : john Raw-SHA256 (crack.txt) ############"
john --wordlist="$RK" --format=Raw-SHA256 crack.txt 2>&1 | grep -iE 'loaded|No password' | head -2
john --show --format=Raw-SHA256 crack.txt

echo
echo "############ TASK 7 : hashcat MD5 straight ############"
hashcat -m 0 -a 0 hash_md5.txt "$RK" --quiet 2>/dev/null
echo "   --show :"; hashcat -m 0 hash_md5.txt --show 2>/dev/null

echo
echo "############ TASK 8 : hashcat combinator (stdout) ############"
hashcat -a 1 --stdout wordlist1.txt wordlist2.txt 2>/dev/null

echo
echo "############ TASK 9 : hashcat MD5 combinator ############"
hashcat -m 0 -a 1 hash_comb.txt wordlist1.txt wordlist2.txt --quiet 2>/dev/null
echo "   --show :"; hashcat -m 0 hash_comb.txt --show 2>/dev/null
