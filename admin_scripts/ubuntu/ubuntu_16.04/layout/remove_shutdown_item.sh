#!/usr/bin/env bash


user=user
dconf_dir=/home/$user/.config/dconf
dconf_dir_cache=/home/$user/.cache/dconf
dconf_dir_hidden=/home/.skjult/.config/dconf
dconf_dir_lightdm=/var/lib/lightdm/.config/dconf

# Make sure gsettings can write to a cache dir
if [ ! -d "$dconf_dir_cache" ]
then
    mkdir -p $dconf_dir_cache
fi

chown $user:$user $dconf_dir_cache

# Run gsettings for disabling shutdown item
su - $user -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-shutdown-menuitem true"


# Make sure dconf dir exists in hidden user
if [ ! -d "$dconf_dir_hidden" ]
then
    mkdir -p $dconf_dir_hidden
fi

# Copy the donf user file to hidden dir
cp $dconf_dir/$user $dconf_dir_hidden/$user


# Make a simple backup of original lightdm dconf file
if [ ! -e $dconf_dir_lightdm/user.org ]
then
    cp $dconf_dir_lightdm/user $dconf_dir_lightdm/user.org
fi

# Run gsettings command on lightdm user, so that shutdown item is disabled in the Unity Greeter
su - lightdm -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-shutdown-menuitem true"
