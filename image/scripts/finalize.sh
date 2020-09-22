#!/usr/bin/env bash

DIR=$(dirname $(realpath $0 ))

cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"

# Copy finalize script to /usr/share/os2borgerpc/bin
cp "$DIR/os2borgerpc-postinstall.sh" /usr/share/os2borgerpc/bin
# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.os2borgerpc_firstboot /etc/lightdm/lightdm.conf
sed -i "s/autologin-user=[a-zA-Z0-9]\+/autologin-user=superuser/" /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse all these changes.
