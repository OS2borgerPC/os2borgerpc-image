#!/usr/bin/env bash


user=user
dconf_dir=/home/user/.cache/dconf


if [ ! -d "$dconf_dir" ]
then
    mkdir -p $dconf_dir
    chown -R $user:$user $dconf_dir
fi

su - $user -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-shutdown-menuitem true"

cp -R $dconf_dir /home/.skjult/.cache
