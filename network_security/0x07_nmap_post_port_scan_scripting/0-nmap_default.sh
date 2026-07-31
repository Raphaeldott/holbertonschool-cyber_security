#!/bin/bash

if [ -z $1 ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

nmap -sC -sV $1

