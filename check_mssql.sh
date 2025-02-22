#!/bin/bash
#This script for Nagios
#Created by @dy
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <host>"
    exit 3
fi
HOST=$1
PORT=1433
if nc -z -w 5 "$HOST" "$PORT" 2>/dev/null; then
    echo "OK - MsSQL Service is running on $HOST"
    exit 0
else
    echo "CRITICAL - MsSQL Service is not running on $HOST"
    exit 2
fi
