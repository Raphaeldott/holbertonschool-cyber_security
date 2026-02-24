#!/bin/bash

i=0
while [ "$i" -lt 200 ]
do
  curl -s -c /dev/null http://web0x01.hbtn/a1/hijack_session/ > /dev/null
  i=$((i + 1))
done
