#!/bin/bash
# Hache le mot de passe donne en $1 avec SHA-1, resultat dans 0_hash.txt
printf '%s' "$1" | sha1sum | awk '{print $1}' > 0_hash.txt
