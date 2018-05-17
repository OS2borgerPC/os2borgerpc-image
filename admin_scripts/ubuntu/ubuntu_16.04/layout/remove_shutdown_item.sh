#!/usr/bin/env bash


user=user
dconf_cache_dir=/home/$user/.cache/dconf
dconf_dir=/home/$user/.config/dconf
dconf_dir_hidden=/home/.skjult/.config/dconf

if [ ! -d "$dconf_dir" ]
then
    mkdir -p $dconf_dir
    chown -R $user:$user $dconf_dir
fi

su - $user -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-shutdown-menuitem true"

mv $dconf_dir $dconf_dir_hidden
