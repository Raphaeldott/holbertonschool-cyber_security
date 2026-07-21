#!/bin/bash
# 4-firewall.sh
# Count how many firewall rules were added

LOG_FILE="auth.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found"
    exit 1
fi

grep -Ei "ufw|firewall|iptables" "$LOG_FILE" | grep -Ei "add|added" | wc -l

