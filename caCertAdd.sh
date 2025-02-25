#!/bin/bash
#Created By @dyadav
#Created on 25_02_2025

if [ ! -d "/var/logs/filemove" ]; then
  mkdir -pv  "/var/logs/filemove/"
fi
#log clear------------------
/usr/bin/find /var/logs/filemove/ -type f -mtime +2 ! -name "*.gz" -exec gzip -9 {} \;
#log clear------------------
logfile='/var/logs/filemove/caCertAdd'`date +"%Y_%m_%d"`'.log'
exec &>> $logfile
IFS=$(echo -en "\n\b")
echo "Script start `date`----------------------------------------------" 
backup="/var/bkps/backups-`date +%F_%H%M%S`"
mkdir -pv $backup
cp -v /var/data/jdk1.8.0_101/jre/lib/security/cacerts $backup
JAVA_CACERTS="/var/data/jdk1.8.0_101/jre/lib/security/cacerts"
STOREPASS="changeit"
URL_LIST="/usr/local/bin/urls.txt" 
TEMP_CERT="/tmp/temp_cert12.crt"

if [ -z "$JAVA_CACERTS" ]; then
    echo "$JAVA_CACERTS is not found. Please set it first."
    exit 1
fi
while IFS= read -r url; do
    if [[ -z "$url" ]]; then
        continue  
    fi
    domain=$(echo "$url" | awk -F[/:] '{print $4}')
    alias_name=$(echo "$domain" | tr '.' '_')
    keytool -list -keystore "$JAVA_CACERTS" -storepass "$STOREPASS" -alias "$alias_name" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "✔ Certificate for $domain is already in the Java keystore."
        continue
    fi
    echo "⏳ Fetching certificate for $domain..."
    echo -n | openssl s_client -connect "$domain":443 -servername "$domain" | \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$TEMP_CERT"
    if [ ! -s "$TEMP_CERT" ]; then
        echo "❌ Failed to fetch certificate for $domain."
        continue
    fi
    echo "🔐 Adding certificate for $domain to Java keystore..."
    keytool -import -trustcacerts -keystore "$JAVA_CACERTS" -storepass "$STOREPASS" -alias "$alias_name" -file "$TEMP_CERT" -noprompt
    if [ $? -eq 0 ]; then
        echo "✅ Certificate for $domain added successfully."
    else
        echo "❌ Failed to add certificate for $domain."
    fi
    rm -f "$TEMP_CERT"
done < "$URL_LIST"
echo "🔄 Keystore update complete!"
echo "Script end `date`----------------------------------------------" 
IFS=$SAVEIFS
