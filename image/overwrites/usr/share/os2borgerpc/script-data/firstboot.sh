#!/usr/bin/env bash

set -e

# switch to normal lightdm timeout
sed --in-place "s/autologin-user-timeout=30/autologin-user-timeout=10/" /etc/lightdm/lightdm.conf

# Install dbus-x11 for dbus-launch from .deb file
dpkg -i /etc/os2borgerpc/*.deb

# Activate superuser desktop shortcuts
USR=superuser
for FILE in /home/$USR/Skrivebord/*.desktop; do
	runuser -u $USR dbus-launch gio set "$FILE" metadata::trusted true
	# In order for gio changes to take effect, it is necessary to update the file time stamp
	touch "$FILE"
done

# setup delayed start of unattended upgrades
TIME_TO_START=$(date -d 'now+2hours' +%FT%R)
mkdir --parents "/usr/local/lib/os2borgerpc"
UNATTENDED_UPGRADES_DELAY="/usr/local/lib/os2borgerpc/unattended_upgrades_delay.py"
UNATTENDED_UPGRADES_DELAY_SERVICE="/etc/systemd/system/os2borgerpc-unattended_upgrades_delay.service"
START_UNATTENDED_UPGRADES="/usr/local/lib/os2borgerpc/start_unattended_upgrades.sh"
cat <<EOF > $UNATTENDED_UPGRADES_DELAY
#!/usr/bin/env python3

import datetime
import time
import subprocess

TIME_TO_START = datetime.datetime.fromisoformat("$TIME_TO_START")

def main():
    while True:
        time.sleep(60)
        NOW = datetime.datetime.now()
        if NOW > TIME_TO_START:
            # Setup unattended upgrades
            subprocess.call("$START_UNATTENDED_UPGRADES")
            break

if __name__ == "__main__":
    main()
EOF

chmod 700 $UNATTENDED_UPGRADES_DELAY

cat <<EOF > $START_UNATTENDED_UPGRADES
#!/usr/bin/env bash

# setup unattended upgrades
"/etc/os2borgerpc/apt_periodic_control.sh" security

# disable the delay service
systemctl disable "$(basename $UNATTENDED_UPGRADES_DELAY_SERVICE)"

# delete the related files
rm --force $UNATTENDED_UPGRADES_DELAY $UNATTENDED_UPGRADES_DELAY_SERVICE $START_UNATTENDED_UPGRADES \
            /etc/os2borgerpc/apt_periodic_control.sh
EOF

chmod 700 $START_UNATTENDED_UPGRADES

cat <<EOF > $UNATTENDED_UPGRADES_DELAY_SERVICE
[Unit]
Description=OS2borgerPC delay unattended upgrades service

[Service]
Type=simple
ExecStart=$UNATTENDED_UPGRADES_DELAY

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now "$(basename $UNATTENDED_UPGRADES_DELAY_SERVICE)"

# Remove the firstboot-related files
rm  /etc/lightdm/greeter-setup-scripts/firstboot.sh /etc/os2borgerpc/*.deb