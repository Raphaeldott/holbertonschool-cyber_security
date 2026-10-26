#!/bin/bash
# Combine le mot de passe ($1) avec un sel aleatoire de 16 caracteres (OpenSSL),
# puis genere un hash SHA-512 du tout avec OpenSSL. Resultat dans 3_hash.txt.
salt=$(openssl rand -hex 8)                       # 8 octets = 16 caracteres hex
printf '%s' "$1$salt" | openssl dgst -sha512 > 3_hash.txt
cat 3_hash.txt
