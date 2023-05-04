#!/bin/bash

# Usage: ./Cert_check.sh <domain>

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain=$1
echo "Checking certificate for $domain..."

expiration_date=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter' | awk -F '=' '{print $2}')
if [ -z "$expiration_date" ]; then
    echo "Error: Unable to extract expiration date for $domain"
    exit 1
fi
echo "Expiration date: $expiration_date"

subject=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -subject | awk -F '=' '{print $NF}' | sed 's/\/.*//')
if [ -z "$subject" ]; then
    echo "Error: Unable to extract subject for $domain"
    exit 1
fi
echo "Domain name: $subject"


renewal_period=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates | grep 'notBefore' | awk -F '=' '{print $2}')
    if [ -z "$renewal_period" ]; then
        echo "Error: Unable to extract renewal period for $domain"
        continue
    fi
    echo "Renewal period: $renewal_period"
