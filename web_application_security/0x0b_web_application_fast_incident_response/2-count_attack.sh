#!/usr/bin/env bash
# 2-count_attack.sh
# Count how many requests the attacker (most frequent IP) has sent

LOG_FILE="logs.txt"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file '$LOG_FILE' not found"
    exit 1
fi

# Step 1: Identify attacker IP (the one with the most requests)
ATTACKER_IP=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# Step 2: Count how many requests this IP has made
COUNT=$(grep -c "^$ATTACKER_IP" "$LOG_FILE")

# Output the number of requests
echo "$COUNT"
