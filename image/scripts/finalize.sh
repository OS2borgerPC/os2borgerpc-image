#!/usr/bin/env bash

USER=superuser

if [ -f ~/.config/user-dirs.dirs ]; then
    source ~/.config/user-dirs.dirs
fi
if [ "$XDG_DESKTOP_DIR" == "" ]; then
    XDG_DESKTOP_DIR="$HOME/Skrivebord"
fi

cp script-data/finalize/*.desktop "${XDG_DESKTOP_DIR}/"
# Copy finalize script to /usr/share/bibos/bin
cp bibos-postinstall.sh /usr/share/bibos/bin
# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.bibos_firstboot /etc/lightdm/lightdm.conf
sed -i "s/autologin-user=[a-zA-Z0-9]\+/autologin-user=$USER/" /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse all these changes.

