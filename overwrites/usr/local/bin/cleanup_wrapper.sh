#!/bin/bash

set >> /tmp/asdf.log

if [ "$USER" == "" ]; then
    USER="$PAM_USER";
fi

if [ "$USER" == "user" ]; then
    sudo /usr/local/bin/user-cleanup.bash
fi
