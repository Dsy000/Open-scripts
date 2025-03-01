#!/bin/bash
# 1 March 2028 @dyadav

LOG_FILE="$1" 
#LOG_FILE="/var/nagios4_data/nagios.log"  # Change this to your actual Nagios log file path
SERVICE_NAME="Tomcat9 heap usage"
OUTPUT_FILE="heap_usage_report_`date +%F_%H%M%S`.txt"

if [[ -f "$LOG_FILE" ]]; then
    echo "File $LOG_FILE exists."
else
    echo "File $LOG_FILE does not exist."
    exit 1
fi

echo "Analyzing Nagios log for '$SERVICE_NAME' service..." > "$OUTPUT_FILE"
echo "=========================================" >> "$OUTPUT_FILE"

total_downtime=0
critical_started=0

# Read the log line by line
while read -r line; do
    timestamp=$(echo "$line" | grep -oP '\[\K[0-9]+(?=\])')
    hostname=$(echo "$line" | awk -F';' '{print $1}' | awk '{print $NF}')  # Extract hostname correctly
    service=$(echo "$line" | awk -F';' '{print $2}')  # Extract service name
    alert_type=$(echo "$line" | awk -F';' '{print $3}')  # Extract alert type
    
    # Only process logs for the target service
    if [[ "$service" == "$SERVICE_NAME" ]]; then
        if [[ "$alert_type" == "CRITICAL" ]]; then
            if [[ $critical_started -eq 0 ]]; then
                critical_started=$timestamp
            fi
        elif [[ "$alert_type" == "OK" ]]; then
            if [[ $critical_started -ne 0 ]]; then
                downtime=$((timestamp - critical_started))
                downtime_min=$((downtime / 60))
                total_downtime=$((total_downtime + downtime))
                echo "Hostname: $hostname | Downtime: $(date -d @$critical_started) to $(date -d @$timestamp) | Duration: $downtime_min min" >> "$OUTPUT_FILE"
                critical_started=0
            fi
        fi
    fi
done < "$LOG_FILE"

echo "----------------------------------------" >> "$OUTPUT_FILE"
echo "Total downtime for '$SERVICE_NAME': $((total_downtime / 60)) minutes" >> "$OUTPUT_FILE"

echo "Report saved to $OUTPUT_FILE"
