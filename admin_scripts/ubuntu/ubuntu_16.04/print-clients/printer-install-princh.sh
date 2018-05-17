#!/usr/bin/env bash


# If Princh is not installed, then install
if [ ! "`which princh`" ]
then
    add-apt-repository -y ppa:princh/experimental
    apt-get update
    apt-get install -y princh

    if [ $? -eq 0 ]
    then
	echo "Hello"
        # Create Princh autostart
        princh_autostart_dir=/home/.skjult/.config/autostart

        if [ ! -d "$princh_autostart_dir" ]
        then
            mkdir -p $princh_autostart_dir
        fi

        ln -sf /usr/share/applications/com-princh-print-daemon.desktop $princh_autostart_dir

        exit 0

    else
        echo "Der opstod et problem ved installation af Princh"
	exit 1
    fi

else
    echo "Princh er allerede installeret"

fi
