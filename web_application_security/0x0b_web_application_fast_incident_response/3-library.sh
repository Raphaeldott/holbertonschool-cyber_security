#!/usr/bin/env bash
# 3-library.sh
# Identify the tool/library used by the attacker by analyzing User-Agent strings

LOG_FILE="logs.txt"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file '$LOG_FILE' not found"
    exit 1
fi

# Step 1: Identify attacker IP (most frequent IP)
ATTACKER_IP=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# Step 2: Extract User-Agent strings for this IP
# User-Agent is usually the last field in Apache/Nginx logs
USER_AGENT=$(grep "^$ATTACKER_IP" "$LOG_FILE" | awk -F\" '{print $6}' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# Output the User-Agent (tool/library)
echo "$USER_AGENT"
