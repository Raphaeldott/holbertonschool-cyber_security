#!/bin/bash

# Vérifier que l'utilisateur a fourni un host
if [ -z $1 ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

# Scanner le port 80 avec le script vulners
nmap --script vulners -p 80 $1

# Scanner le port 443 avec le script vulners
nmap --script vulners -p 443 $1

