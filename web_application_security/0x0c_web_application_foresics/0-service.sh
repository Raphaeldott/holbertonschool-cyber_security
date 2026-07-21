#!/bin/bash
# 0-service.sh
# Advanced version: reproduce Holberton example output

LOG_FILE="auth.log"

if [ ! -f $LOG_FILE ]; then
    echo "Log file not found"
    exit 1
fi

# Extract all PAM-related tokens and authentication messages
grep -oE "pam_unix\([^)]*\)|Failed|Invalid|Accepted|error:|Address|reverse|Did|Server|subsystem|syslogin_perform_logout:|Received|PAM|Bad|new|changed|change|Kayn|Exiting" "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -nr
