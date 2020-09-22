#!/bin/bash

# TODO: Maybe use a more standardized method than ".skjult".
#this script cleans up the users home directory

USERNAME="user"


	rm -fr /tmp/* /tmp/.??*
	rm -rf /home/$USERNAME
        # Remove pending print jobs
        PRINTERS=$(lpstat -p | grep printer | awk '{ print $2; }')

        for PRINTER in $PRINTERS
        do
            lprm -P $PRINTER -
        done
 
        # Restore $HOME
	rsync -vaz /home/.skjult/ /home/$USERNAME/
	chown -R $USERNAME:$USERNAME /home/$USERNAME

	# copy desktop icons
	cp /home/.skjult/Desktop/* /home/$USERNAME/Desktop/
	chown -R $USERNAME:$USERNAME /home/$USERNAME/Desktop
	chmod +x /home/$USERNAME/Desktop/*

