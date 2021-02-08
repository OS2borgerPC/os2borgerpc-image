#!/usr/bin/env bash

if [ $# -ne 1 ]
then
    echo "usage: $(basename $0) <on/off>"
    echo "Assuming you meant 'on'..."
fi

#install the numlock utility:
echo
echo "installing numlockx utility..."
sudo apt-get install numlockx -y --force-yes

#remove previous numlock entries with simple check for "N/numlock" string
sudo sed -i_bak -e /[Nn]umlock/d /etc/rc.local


if [ "$1" == "off" ]
then
	echo
	echo "Setting boot numlock to OFF"
	#Make sure it's off with: 
	sudo sed -i 's|^exit 0.*$|# Numlock DISABLE on boot:\n[ -x /usr/bin/numlockx ] \&\& numlockx off\nexit 0|' /etc/rc.local
	echo
	echo "Done, enjoy your new numberless keyboard :)"
	exit 0
else
	echo
	echo "Setting boot numlock to ON"

	#Add numlock on lines to /etc/rc.local:	
	echo
	echo "editing /etc/rc.local to enable numlock on boot..."
	sudo sed -i 's|^exit 0.*$|# Numlock enable on boot:\n[ -x /usr/bin/numlockx ] \&\& numlockx on\nexit 0|' /etc/rc.local
	echo
	echo "Done. Enjoy your number keys :)"
	echo
	exit 0
fi


