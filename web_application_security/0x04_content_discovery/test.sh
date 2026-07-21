for f in flag task4 payment process gateway debug secret hidden admin; do
  url="http://web0x04.hbtn/payment_gateway/$f.php"
  echo -n "$url → "
  curl -m 10 -s -o /dev/null -w "%{http_code}\n" $url
done
