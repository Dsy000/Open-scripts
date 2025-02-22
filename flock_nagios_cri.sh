#!/bin/bash
#@dyadav
#this for host
# Set variables from command line arguments
WEBHOOK_URL="Your_url"

# Set Flock notification message
MESSAGE="<flockml><b>************************</b><br><b>Notification Type:</b> $1<br><b>Service:</b> $2<br><b>Host:</b> $3<br><b>Address:</b> $4<br><b>State:</b> $5<br><b>Date/Time:</b> $6<br><b>Additional Info:</b><br>$7<br></flockml>"
# Send notification to Flock
curl -X POST -H 'Content-type: application/json' --data "{\"flockml\":\"$MESSAGE\"}" $WEBHOOK_URL
