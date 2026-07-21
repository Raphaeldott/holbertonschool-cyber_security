#!/bin/bash
# 1-operating.sh
# Extract the OS version from dmesg

LOG_FILE="dmesg"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found"
    exit 1
fi

grep -m 1 "Linux version" "$LOG_FILE"
