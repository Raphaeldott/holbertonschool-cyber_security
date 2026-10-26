#!/bin/bash
# Hache le mot de passe donne en $1 avec SHA-256, resultat dans 1_hash.txt
printf '%s' "$1" | sha256sum | awk '{print $1}' > 1_hash.txt
