#!/bin/bash
# 2-accounts.sh
# Identify compromised account from last 1000 lines of auth.log

LOG_FILE="auth.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found"
    exit 1
fi

# Analyse last 1000 lines
tail -n 1000 "$LOG_FILE" > tmp_auth.log

# Find users with failed attempts
FAILED_USERS=$(grep "Failed password" tmp_auth.log | awk '{print $9}' | sort | uniq)

# Check which of these users later had a successful login
for user in $FAILED_USERS
do
    if grep -q "Accepted password for $user" tmp_auth.log; then
        echo "$user"
        rm tmp_auth.log
        exit 0
    fi
done

rm tmp_auth.log
