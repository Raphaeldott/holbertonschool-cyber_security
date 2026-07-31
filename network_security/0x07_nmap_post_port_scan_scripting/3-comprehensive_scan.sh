#!/bin/bash

# Vérifier que l'utilisateur a fourni un host
if [ -z $1 ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

# Lancer les scripts NSE séquentiellement et sauvegarder la sortie
{
    echo "=== Apache Struts 2 CVE-2017-5638 Scan ==="
    nmap --script http-vuln-cve2017-5638 $1

    echo ""
    echo "=== SSL/TLS Cipher Enumeration ==="
    nmap --script ssl-enum-ciphers $1

    echo ""
    echo "=== Anonymous FTP Login Check ==="
    nmap --script ftp-anon $1
} > comprehensive_scan_results.txt

