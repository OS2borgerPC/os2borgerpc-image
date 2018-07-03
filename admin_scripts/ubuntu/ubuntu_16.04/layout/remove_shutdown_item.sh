#!/usr/bin/env bash


user=user
dconf_dir=/home/$user/.config/dconf
dconf_dir_cache=/home/$user/.cache/dconf
dconf_dir_hidden=/home/.skjult/.config/dconf

if [ ! -d "$dconf_dir_cache" ]
then
    mkdir -p $dconf_dir_cache
fi

chown $user:$user $dconf_dir_cache

su - $user -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-shutdown-menuitem true"

if [ ! -d "$dconf_dir_hidden" ]
then
    mkdir -p $dconf_dir_hidden
fi

cp $dconf_dir/$user $dconf_dir_hidden/$user
