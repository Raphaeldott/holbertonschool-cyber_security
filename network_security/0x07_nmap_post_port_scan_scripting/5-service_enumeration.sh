#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

nmap -A \
    --script=banner,ssl-enum-ciphers,default,smb-enum-domains \
    $1 \
    > service_enumeration_results.txt

