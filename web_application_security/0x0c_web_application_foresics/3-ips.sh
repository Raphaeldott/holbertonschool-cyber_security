#!/bin/bash
# 3-ips.sh
# Count distinct attackers (unique IPs with successful login)

LOG_FILE="auth.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found"
    exit 1
fi

# Extract IPs from successful logins
grep "Accepted password" "$LOG_FILE" \
    | awk '{print $11}' \
    | sort \
    | uniq \
    | wc -l
