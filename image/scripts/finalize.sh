#!/usr/bin/env bash

DIR=$(dirname "$(realpath "$0" )")

mkdir -p /home/superuser/Skrivebord
mkdir /home/superuser/.config
echo "yes" > /home/superuser/.config/gnome-initial-setup-done

chown -R superuser:superuser /home/superuser


cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"

# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.os2borgerpc_firstboot /etc/lightdm/lightdm.conf
# The PostInstall script will switch to the "normal" lightdm.conf for
# os2borgerpc, ensuring cleanup of user's directory.

# Setup cleanup script in systemd.
"$DIR/systemd_policy_cleanup.sh" 1


# Automatic login for user, not superuser.
if [[ -f /etc/lightdm/lightdm.conf.os2borgerpc ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    mv /etc/lightdm/lightdm.conf.os2borgerpc /etc/lightdm/lightdm.conf
fi
