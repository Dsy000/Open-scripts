#!/bin/bash
# Created by @DY.
# Usage: ./Cert_check.sh <domain_file>

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain_file>"
    exit 1
fi

domain_file=$1

while read -r domain; do
    echo "Checking certificate for $domain..."

    expiration_date=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter' | awk -F '=' '{print $2}')
    if [ -z "$expiration_date" ]; then
        echo "Error: Unable to extract expiration date for $domain"
        continue
    fi
    echo "Expiration date: $expiration_date"

    renewal_period=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates | grep 'notBefore' | awk -F '=' '{print $2}')
    if [ -z "$renewal_period" ]; then
        echo "Error: Unable to extract renewal period for $domain"
        continue
    fi
    echo "Renewal period: $renewal_period"

    subject=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -subject | awk -F '=' '{print $NF}' | sed 's/\/.*//')
    if [ -z "$subject" ]; then
        echo "Error: Unable to extract subject for $domain"
        continue
    fi
    echo "Domain name: $subject"

done < "$domain_file"
