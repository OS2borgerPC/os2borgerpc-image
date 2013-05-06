#!/bin/bash

set >> /tmp/asdf.log

if [ "$USER" == "" ]; then
    USER="$PAM_USER";
fi

if [ "$USER" == "user" ]; then
    sudo /opt/bibos/bin/user-cleanup.bash
fi
