#!/usr/bin/env bash


set -e


# If Princh is not installed, install
if [ ! "`which princh`" ]
then	
    add-apt-repository -y ppa:princh/experimental
    apt-get update
    apt-get install -y princh
else
    echo "Princh er allerede installeret"
fi

# Create Princh autostart
princh_autostart_dir=/home/.skjult/.config/autostart

if [ ! -d "$princh_autostart_dir" ]
then
    mkdir -p $princh_autostart_dir
fi

ln -sf /usr/share/applications/com-princh-print-daemon.desktop $princh_autostart_dir

exit 0
