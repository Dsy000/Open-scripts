#!/bin/bash
# This for nagios.
# Created by dyadav - Update 24 Dec,2024
if [ ! -d "/var/logs/filemove" ]; then
  mkdir -pv  "/var/logs/filemove/"
fi
#log clear------------------
/usr/bin/find /var/logs/filemove/ -type f -mtime +2 ! -name "*.gz" -exec gzip -9 {} \;
#log clear------------------
logfile='/var/logs/filemove/adduser'`date +"%Y_%m_%d"`'.log'

# Define your user list start---------------------------------------

# This for admin access
admin_users="dyadav"    #Enter username list.

# This for read only access.
readOnly_user="akumar"   
# Define your user list end---------------------------------------

# Path to the cgi.cfg file
cgi_cfg="/usr/local/nagios/etc/cgi.cfg"
if [ ! -d "/var/bkps/config_nagios/" ]; then
  mkdir -pv /var/bkps/config_nagios/
fi
cp -v $cgi_cfg /var/bkps/config_nagios/cgi.cfg-`date +%F_%H%M%S`
# Use `sed` to replace the relevant lines in the cgi.cfg file
sed -i "s/^authorized_for_system_information=.*/authorized_for_system_information=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_configuration_information=.*/authorized_for_configuration_information=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_system_commands=.*/authorized_for_system_commands=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_all_services=.*/authorized_for_all_services=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_all_hosts=.*/authorized_for_all_hosts=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_all_service_commands=.*/authorized_for_all_service_commands=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_all_host_commands=.*/authorized_for_all_host_commands=$admin_users/" $cgi_cfg
sed -i "s/^authorized_for_read_only=.*/authorized_for_read_only=$readOnly_user/" $cgi_cfg
# Restart Nagios to apply the changes
sudo systemctl restart nagios
echo "Change Output"
cat $cgi_cfg | grep 'authorized_for_'
echo "[`date`] Adding user in nagios, admin: {$admin_users}, readOnly: {$readOnly_user}"  >> $logfile
