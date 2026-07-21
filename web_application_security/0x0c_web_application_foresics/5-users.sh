#!/bin/bash
# 5-users.sh
# List all users created or present on the system based on auth.log activity

LOG_FILE="auth.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found"
    exit 1
fi

# Extract all usernames appearing in auth.log
grep -oE "for [a-zA-Z0-9_-]+" "$LOG_FILE" \
    | awk '{print $2}' \
    | sort \
    | uniq \
    | paste -sd ","

