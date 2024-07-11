#!/bin/bash
#Created by: dy
# Function to check if host is up
check_host() {
    host=$1
    ping -c 1 $host > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Host $host is up"
    else
        echo "Host $host is down"
    fi
}

# Check if file exists and is readable
hosts_file="hosts.txt"
if [ ! -f $hosts_file ]; then
    echo "Error: File $hosts_file not found."
    exit 1
fi

# Read each line from the file and check the host
while IFS= read -r host || [ -n "$host" ]; do
    check_host "$host"
done < "$hosts_file"
