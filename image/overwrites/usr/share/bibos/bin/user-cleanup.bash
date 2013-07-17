#!/bin/bash

#this script cleans up the users home directory

USERNAME="user"


	rm -fr /tmp/* /tmp/.??*
	rm -rf /home/$USERNAME
        # Remove pending print jobs
        lprm -
        # Restore $HOME
	rsync -vaz /home/.skjult/ /home/$USERNAME/
	chown -R $USERNAME:$USERNAME /home/$USERNAME

	# copy desktop icons
	cp /home/.skjult/Desktop/* /home/$USERNAME/Desktop/
	chown -R $USERNAME:$USERNAME /home/$USERNAME/Desktop
	chmod +x /home/$USERNAME/Desktop/*

