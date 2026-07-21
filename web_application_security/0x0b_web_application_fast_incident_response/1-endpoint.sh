#!/usr/bin/env bash
# 1-endpoint.sh
# Identify the endpoint (URL) that received the most requests in logs.txt

LOG_FILE="logs.txt"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file '$LOG_FILE' not found"
    exit 1
fi

# Extract endpoints, count them, sort by frequency, print the most requested one
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
