#!/bin/bash

#this script cleans up the users home directory

USERNAME="user"

if [ -d /home/$USERNAME ]; then

	rm -fr /tmp/* /tmp/.??*
	rm -r /home/$USERNAME
        # Remove pending print jobs
        lprm -U $USERNAME
	rsync -vaz /home/.skjult/ /home/$USERNAME/
	chown -R $USERNAME:$USERNAME /home/$USERNAME

	# copy desktop icons
	cp /home/.skjult/Desktop/* /home/$USERNAME/Desktop/
	chown -R $USERNAME:$USERNAME /home/$USERNAME/Desktop
	chmod +x /home/$USERNAME/Desktop/*
fi

