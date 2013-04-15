#!/usr/bin/env bash

# Manual fix for BibOS 1.5
# Completely turn off screensaver, including BIOS power saving.


XSESSION_TMP=/tmp/xsession_${RANDOM}
TARGET_FILE=/home/.skjult/.xsessionrc

cat << EOF > $XSESSION_TMP
#!/usr/bin/env bash

xset s off
xset -dpms

EOF

if [ -d /home/.skjult ] 
then 
    gksudo mv $XSESSION_TMP $TARGET_FILE
    gksudo chmod a+x $TARGET_FILE
    zenity --info --text "Opdateringen er installeret!"
else 
    zenity --warning --text "Dette er ikke en BibOS-maskine"
fi


