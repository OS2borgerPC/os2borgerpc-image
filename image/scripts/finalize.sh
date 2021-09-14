#!/usr/bin/env bash

DIR=$(dirname "$(realpath "$0" )")

cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"

# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
cp /etc/lightdm/lightdm.conf.os2borgerpc_firstboot /etc/lightdm/lightdm.conf
# The PostInstall script will switch to the "normal" lightdm.conf for
# os2borgerpc, ensuring cleanup of user's directory.

# Setup cleanup script in systemd.
"$DIR/../../admin_scripts/image_core/systemd_policy_cleanup.sh" 1


# Automatic login for user, not superuser.
if [[ -f /etc/lightdm/lightdm.conf.os2borgerpc ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    mv /etc/lightdm/lightdm.conf.os2borgerpc /etc/lightdm/lightdm.conf
fi

# BLOCK ACCESS TO SETTINGS FOR THE USER BUT NOT SUPERUSER {{{
# Related: https://os2borgerpc-admin.magenta.dk/site/magenta/scripts/748/

dpkg-divert --rename --divert  /usr/bin/gnome-control-center.real --add /usr/bin/gnome-control-center
dpkg-statoverride --update --add superuser root 770 /usr/bin/gnome-control-center.real


cat <<- EOF > /usr/bin/gnome-control-center 
	#!/bin/bash
	
	USER=\$(id -un)
	
	if [ \$USER == "user" ]; then
	  zenity --info --text="Systemindstillingerne er ikke tilgængelige for publikum.\n\n Kontakt personalet, hvis der er problemer."
	else
	  /usr/bin/gnome-control-center.real
	fi
EOF

chmod +x /usr/bin/gnome-control-center

# /BLOCK ACCESS TO SETTINGS }}}
