#!/bin/bash

# Vérifier que l'utilisateur a fourni un host
if [ -z $1 ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

# Exécuter le script NSE http-vuln-cve2017-5638 et sauvegarder la sortie
nmap --script http-vuln-cve2017-5638 $1 > vuln_scan_results.txt

