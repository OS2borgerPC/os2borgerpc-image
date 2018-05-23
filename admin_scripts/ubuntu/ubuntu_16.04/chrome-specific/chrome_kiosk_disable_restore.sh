#!/bin/bash

set -e


if [ $# -ne 1 ]
then
    echo "Dette script skal bruge to parametre: brugernavn og hjemmeside"
    exit -1
fi

user=$1
site=$2


# Create exec script for Chrome
cat <<CHROME-EXEC > /home/$user/.chrome.sh
#!/usr/bin/env bash

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/$user/.config/google-chrome/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"None"/' /home/$user/.config/google-chrome/Default/Preferences
sed -i 's/"restore_on_startup":[0-9]/"restore_on_startup":0/' /home/$user/.config/google-chrome/Default/Preferences
google-chrome --kiosk $site --full-screen
CHROME-EXEC

chmod +x /home/$user/.chrome.sh


# Make the Chrome-script autostart
autostart_dir=/home/$user/.config/autostart

if [ ! -d "$autostart_dir" ]
then
    mkdir -p $autostart_dir
fi

cat <<CHROME-DESKTOP > $autostart_dir/chrome.desktop
[Desktop Entry]
Type=Application
Exec=/home/$user/.chrome.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Chrome
Name=Chrome
Comment[en_US]=run the Google-chrome webbrowser at startup
Comment=run the Google-chrome webbrowser at startup
Name[en]=Chrome
CHROME-DESKTOP


exit 0
