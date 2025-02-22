#!/bin/bash
#@dy
# Define the container name
CONTAINER_NAME="$1"

# Check if container name is provided
if [ -z "$CONTAINER_NAME" ]; then
    echo "UNKNOWN - Container name is missing"
    exit 3
fi

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "CRITICAL - Docker is not installed"
    exit 2
fi

# Get the container status
CONTAINER_STATUS=$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)

# Check if the container exists
if [ $? -ne 0 ]; then
    echo "CRITICAL - Container '$CONTAINER_NAME' not found"
    exit 2
fi

# Check if the container is running
if [ "$CONTAINER_STATUS" == "true" ]; then
    echo "OK - Container '$CONTAINER_NAME' is running"
    exit 0
else
    echo "CRITICAL - Container '$CONTAINER_NAME' is not running"
    exit 2
fi
