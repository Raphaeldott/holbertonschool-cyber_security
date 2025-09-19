#!/bin/bash
whois $1|egrep '^(Registrant|Admin|Tech)'|awk -F': ' '{print $1","$2}' > $1.csv
