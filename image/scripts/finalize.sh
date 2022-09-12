#!/usr/bin/env bash


printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

DIR=$(dirname "$(realpath "$0" )")

mkdir --parents /home/superuser/Skrivebord /home/superuser/.config
echo "yes" > /home/superuser/.config/gnome-initial-setup-done

chown -R superuser:superuser /home/superuser


cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"

# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.os2borgerpc_firstboot /etc/lightdm/lightdm.conf
# The PostInstall script will switch to the "normal" lightdm.conf for
# os2borgerpc, ensuring cleanup of user's directory.

# Setup cleanup script in systemd.
# Suppress output as it will try to reload/start the systemd service which will fail,
# as the script is usually being run on a running BorgerPC
"$DIR/systemd_policy_cleanup.sh" 1 > /dev/null


# Automatic login for user, not superuser.
if [[ -f /etc/lightdm/lightdm.conf.os2borgerpc ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    mv /etc/lightdm/lightdm.conf.os2borgerpc /etc/lightdm/lightdm.conf
fi
