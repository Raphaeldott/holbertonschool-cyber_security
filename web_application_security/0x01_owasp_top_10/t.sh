i=1
while [ "$i" -le 10 ]
do
  curl -s -c "j$i.txt" http://web0x01.hbtn/a1/hijack_session/ > /dev/null
  i=$((i + 1))
done
