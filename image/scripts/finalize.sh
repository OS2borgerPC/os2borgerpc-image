#!/usr/bin/env bash

DIR=$(dirname $(realpath $0 ))

cp "$DIR/overwrites/usr/share/bibos/script-data/finalize/*.desktop" "/home/superuser/Skrivebord"
# Copy finalize script to /usr/share/bibos/bin
cp bibos-postinstall.sh /usr/share/bibos/bin
# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.bibos_firstboot /etc/lightdm/lightdm.conf
sed -i "s/autologin-user=[a-zA-Z0-9]\+/autologin-user=superuser/" /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse all these changes.
