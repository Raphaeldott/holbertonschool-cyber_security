for u in $(curl -s http://web0x04.hbtn/mpg-sitemap-world-cities.xml| grep -oP '(?<=<loc>).*?(?=</loc>)'); do
  echo "==> $u"
  curl -s "$u" | grep -i flag
done
