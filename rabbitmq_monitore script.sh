#!/bin/bash

RABBITMQ_USER="admin"
RABBITMQ_PASSWORD="admin"
RABBITMQ_HOST="172.16.1.55"  #Your rabbit MQ host ip
RABBITMQ_PORT="15672"
QUEUES=$(curl -s -u $RABBITMQ_USER:$RABBITMQ_PASSWORD \
    http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/queues | jq -r '.[].name')

if [ -z "$QUEUES" ]; then
    echo "CRITICAL: No queues found or unable to connect to RabbitMQ."
    exit 2
fi
TOTAL_PENDING=0
PENDING_QUEUES=""
for QUEUE in $QUEUES; do
    PENDING_MESSAGES=$(curl -s -u $RABBITMQ_USER:$RABBITMQ_PASSWORD \
        http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/queues/%2F/$QUEUE | jq '.messages')
    
    if [ "$PENDING_MESSAGES" -gt 0 ]; then
        PENDING_QUEUES+="$QUEUE: $PENDING_MESSAGES messages pending\n"
        TOTAL_PENDING=$((TOTAL_PENDING + PENDING_MESSAGES))
    fi
done

if [ "$TOTAL_PENDING" -eq 0 ]; then
    echo "OK: No pending messages in any queue."
    exit 0
else
    echo -e "WARNING: Pending messages in queues:\n$PENDING_QUEUES"
    exit 1
fi
