#!/bin/bash
# Combine deux wordlists ($1 et $2) avec hashcat (mode combinator -a 1) et affiche le resultat.
hashcat -a 1 --stdout "$1" "$2"
