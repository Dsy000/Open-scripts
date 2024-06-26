#inotifywait is a command-line utility that can be used to monitor changes to files and directories in Linux. 
#sudo apt-get install inotify-tools
#Use: inotifywait -m -e create -e delete -e modify /path/to/directory

#!/bin/bash
# Define the directory to monitor
DIRECTORY_TO_MONITOR="/path/to/directory"

# Define the output log file
OUTPUT_LOG_FILE="/var/log/inotifywait.log"

# Run inotifywait to monitor the directory and its subdirectories
inotifywait -m -r -e create -e delete -e modify "$DIRECTORY_TO_MONITOR" --format '%T %w %f %e' --timefmt '%Y-%m-%d %H:%M:%S' >> "$OUTPUT_LOG_FILE"



#--------------------------------------------------------
#Create service:
#vim /etc/systemd/system/monitor.service
[Unit]
Description=Inotifywait Directory Monitor
After=network.target

[Service]
ExecStart=/usr/local/bin/monitor.sh
Restart=on-failure
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
#----------------------------------------
#Start and enable service.
sudo systemctl daemon-reload
sudo systemctl start monitor.service
sudo systemctl enable monitor.service


