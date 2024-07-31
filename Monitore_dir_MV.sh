#Use: Monitore SOURCE_DIR dir if any file come then move on DESTINATION_DIR with time stemp


#V1 ---------------------------------------------------------------------------------------------------------------------
#!/bin/bash
SOURCE_DIR="/mnt/jail/dir1"
DESTINATION_DIR="/mnt/jail/dir2"
if ! command -v inotifywait &> /dev/null; then
    echo "inotify-tools not found. Installing..." 
fi
inotifywait -m -e close_write --format '%f' "$SOURCE_DIR" | while read NEW_FILE
do
    while lsof | grep "$SOURCE_DIR/$NEW_FILE" &> /dev/null
    do
        sleep 1
    done
    sleep 5
    currenttime="`date +%y%m%d%H%M%S`_"
    new_name="$currenttime$NEW_FILE"
    mv "$SOURCE_DIR/$NEW_FILE" "$DESTINATION_DIR/$new_name"
    echo "Moved $NEW_FILE to $DESTINATION_DIR/$new_name"
done

#V2 ---------------------------------------------------------------------------------------------------------------------
