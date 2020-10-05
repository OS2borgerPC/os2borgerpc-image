#!/usr/bin/env bash

DIR=$(dirname $(realpath $0 ))

cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"

# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.os2borgerpc_firstboot /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse the changes to LightDM configuration.
