#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    remove_shutdown_item.sh
#%
#% DESCRIPTION
#%    This script disables shutdown options from the settings
#%    menu in Ubuntu 16.04 for user user.
#%
#================================================================
#- IMPLEMENTATION
#-    version         remove_shutdown_item (magenta.dk) 0.0.1
#-    author          Andreas Natanel
#-    copyright       Copyright 2018, Magenta Aps"
#-    license         GNU General Public License
#-    email           ann@magenta.dk
#-
#================================================================
#  HISTORY
#     2018/11/06 : andreas : Script creation
#     2018/09/07 : danni : The script could not connect to dbus
#     when user was logged in. This should be fixed now.
#     2018/12/12 : danni : restart menuitem was not removed.
#     Wrong gsetting was used. Now fixed.
#
#================================================================
# END_OF_HEADER
#================================================================

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

user_logged_in=$(who | cut -f 1 -d ' ' | sort | uniq | grep $user)

set -e

if [ $user_logged_in ]
then
    # Run gsettings with X.
    export DISPLAY=:0.0
    export XAUTHORITY=/home/$user/.Xauthority
fi

# Run gsettings for disabling shutdown item
su - $user -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-shutdown-menuitem true"
su - $user -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-logout-restart-shutdown true"

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
su - lightdm -s /bin/bash -c "dbus-launch --exit-with-session gsettings set com.canonical.indicator.session suppress-logout-restart-shutdown true"
