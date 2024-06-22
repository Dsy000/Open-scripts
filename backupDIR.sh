#!/bin/bash
#Created by @DY
#Nav Backup dir maker
attempt=0
max_attempts=6
while [ $attempt -lt $max_attempts ]; do
    read -p "Enter a folder name (must be more than 4 characters): " folder_name
    if [[ -n $folder_name && ${#folder_name} -gt 4 ]]; then
        echo "Folder name '$folder_name' is valid."
        mkdir -pv /var/bkps/${folder_name}/backups-`date +%F_%H%M%S`
        break
    else
        echo "Invalid folder name. Please try again."
        ((attempt++))
    fi
    if [ $attempt -eq $max_attempts ]; then
        echo "Maximum attempts reached. Exiting..."
        exit 1
    fi
done
