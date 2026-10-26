#!/bin/bash
# Hache le mot de passe donne en $1 avec MD5, resultat dans 2_hash.txt
printf '%s' "$1" | md5sum | awk '{print $1}' > 2_hash.txt
