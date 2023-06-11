#!/bin/bash

syslog_file="/var/log/syslog"

# Check if the syslog file exists
if [ ! -f "$syslog_file" ]; then
    echo "Syslog file not found."
    exit 1
fi

# Continuously monitor the syslog file
tail -fn0 "$syslog_file" | while read -r line; do
    # Check if the line contains the specified string
    if echo "$line" | grep -q "driver own failed"; then
        # Produce a beep sound alert
        echo -e "\a"
        notify-send "Syslog Alert" "The string 'driver own failed' was found in the syslog file."
    fi
done