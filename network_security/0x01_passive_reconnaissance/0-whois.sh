#!/bin/bash
whois "$1"|awk -F': ' -vOFS=, '/^(Registrant|Admin|Tech)/{print $1,$2}'>$1.csv
