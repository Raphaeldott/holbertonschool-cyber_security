#!/usr/bin/env bash
# 0-attack_ip.sh
# Identify the IP address responsible for the most requests in logs.txt

LOG_FILE="logs.txt"

# Ensure log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file '$LOG_FILE' not found"
    exit 1
fi

# Extract IPs (assuming IP is the first field), count, sort by count, print top IP
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
