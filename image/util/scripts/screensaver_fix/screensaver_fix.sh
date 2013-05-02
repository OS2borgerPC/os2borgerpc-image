#!/usr/bin/env bash

# Manual fix for BibOS 1.5
# Completely turn off screensaver, including BIOS power saving.


XSESSION_TMP=/tmp/xsession_${RANDOM}
BIBOS_INSTALL_DIR=/home/.skjult
TARGET_FILE=${BIBOS_INSTALL_DIR}/.xsessionrc

cat << EOF > $XSESSION_TMP
#!/usr/bin/env bash

xset s off
xset -dpms

EOF

if [[ -d $BIBOS_INSTALL_DIR ]] 
then 
    gksudo mv $XSESSION_TMP $TARGET_FILE && chmod a+x $TARGET_FILE
    # Check if successful or not
    if [[ ! -z $(grep dpms $TARGET_FILE) ]]
    then
        zenity --info --text "Opdateringen er installeret!"
    else 
        zenity --info --text "Opdateringen mislykkedes - check password"
    fi
else 
    zenity --warning --text "Dette er ikke en BibOS-maskine"
fi


