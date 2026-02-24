#!/bin/bash

i=1
while [ "$i" -le 10 ]
do
  curl -s -c "j$i.txt" http://web0x01.hbtn/a1/hijack_session/ > /dev/null

  echo -n "Session $i → "
  awk '/hijack_session/ {print $NF}' "j$i.txt"

  i=$((i + 1))
done
