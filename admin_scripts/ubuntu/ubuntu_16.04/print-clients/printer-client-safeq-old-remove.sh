#!/usr/bin/env bash


old_safeq_files=(
"/etc/xdg/autostart/sqport.desktop"
"/etc/sqclient.conf"
"/etc/dbus-1/system.d/sqport.conf"
"/etc/logrotate.d/sqport"
"/usr/local/share/pixmaps/sqport/ysoft_logo.ico"
"/usr/local/share/pixmaps/sqport/ysoft_logo.png"
"/usr/local/share/pixmaps/sqport/ysoft_logo.gif"
"/usr/local/bin/sqport_gui"
"/usr/local/bin/sqport_gui.pyc"
"/usr/share/applications/sqport.desktop"
"/usr/share/autostart/sqport.desktop"
"/usr/lib/cups/backend/sqport"
"/usr/lib/cups/backend/sqport.pyc"
"/var/log/cups/sqclient_backend.log"
)

# Stop CUPSD
service cups stop

# Remove the old safeq client, but not the ppd files in the /opt folder (bibos_safeq_install_2.sh)
for file in "${old_safeq_files[@]}"
do
    rm -frv $file
done

# Start CUPSD again
service cups start
