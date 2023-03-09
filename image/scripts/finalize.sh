#!/usr/bin/env bash


printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

DIR=$(dirname "$(realpath "$0" )")

mkdir --parents /home/superuser/Skrivebord /home/superuser/.config/autostart
echo "yes" > /home/superuser/.config/gnome-initial-setup-done


cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"

chown -R superuser:superuser /home/superuser


# Setup cleanup script in systemd.
# Suppress output as it will try to reload/start the systemd service which will fail,
# as the script is usually being run on a running BorgerPC
"$DIR/systemd_policy_cleanup.sh" 1 > /dev/null

# Setup autostart of the firstboot script that runs when lightdm is reached for the first time
mv /usr/share/os2borgerpc/script-data/firstboot.sh /etc/lightdm/greeter-setup-scripts/


# Enable FSCK automatic fixes
sed --in-place "s/FSCKFIX=no/FSCKFIX=yes/" /lib/init/vars.sh
