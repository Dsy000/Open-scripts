sudo apt-get install inotify-tools

--------------------------------------------------
vim /usr/local/bin/monitore.sh
#!/bin/bash

inotifywait -m -r -e create -e delete -e modify /test | while read path action file; do
    echo "[`date`] The file '$file' at '$path' was '$action'" >> log.log
done


#OR ~~~~~~~~~~~~~~~~~~~~~~

#!/bin/bash

DIRECTORY_TO_MONITOR="/path/to/directory"
OUTPUT_LOG_FILE="/var/log/inotifywait.log"

inotifywait -m -r -e create -e delete -e modify "$DIRECTORY_TO_MONITOR" --format '%T %w %f %e' --timefmt '%Y-%m-%d %H:%M:%S' >> "$OUTPUT_LOG_FILE"

---------------------------------------------------
vim /etc/systemd/system/jail_monitor.service

[Unit]
Description=jail Directory Monitor
After=network.target

[Service]
ExecStart=/usr/local/bin/monitor.sh
Restart=on-failure
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target

-------------------------------------------------
sudo systemctl daemon-reload
sudo systemctl start monitor.service
sudo systemctl enable monitor.service
