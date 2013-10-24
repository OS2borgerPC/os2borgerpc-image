#!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This includes:
#
# * Printer and other hardware setup
# * Proprietary packages which we're not allowed to distribute
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# Get proxy-environment if needed
source /usr/share/bibos/env/proxy.sh


zenity --info --text="Konfigurér printere i den efterfølgende dialog\nLuk dialogen for at fortsætte installationen"

# Printer setup
system-config-printer

# Proprietary stuff

# Ensure Internet connection 

zenity --info --text="Du har brug for en forbindelse til Internettet for at fortsætte"      

# 1. Codecs, Adobe Flash, etc.

zenity --question  --text="Installér Adobe Flash og Microsoft fonts?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    apt-get update
    apt-get -y install ubuntu-restricted-extras 
fi


# 2. Skype

zenity --question --text="Installér Skype?"

if [[ $? -eq 0 ]]
then
     ATTEMPTED_INSTALL=1
     add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
     apt-get update  
     apt-get -y install skype 
fi

if [[ ! -z $ATTEMPTED_INSTALL ]]
then

    if [[ $? -eq 0 ]]
    then
        zenity --info --text="Skype er installeret!"
    else
        zenity --error --text="Skype-installationen mislykkedes! Prøv eventuelt at\
            installere den manuelt fra Ubuntu Software Center."
    fi
fi

# 3. Google Chrome (real deal, no Chromium)

zenity --question --text="Installér Google Chrome?"

if [[ $? -eq 0 ]] 
then
    # Install it.
    # Follow procedure described here:
    # http://www.howopensource.com/2011/10/install-google-chrome-in-ubuntu-11-10-11-04-10-10-10-04/
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    apt-get update
    apt-get -y install google-chrome-stable

# Make default browser globally
update-alternatives --set x-www-browser /usr/bin/google-chrome

# Make default browser for user
cat << EOF > /tmp/mimeapps.list


[Default Applications]
text/html=google-chrome.desktop
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
x-scheme-handler/about=google-chrome.desktop
x-scheme-handler/unknown=google-chrome.desktop

EOF

mkdir -p /home/.skjult/.local/share/applications
mv /tmp/mimeapps.list /home/.skjult/.local/share/applications

   # Install desktop icon

cat << EOF > /tmp/google-chrome.desktop
[Desktop Entry]
Version=1.0
Name=Chrome Internetbrowser
# Gnome and KDE 3 uses Comment.
Comment=Access the Internet
Comment[ar]=الدخول إلى الإنترنت
Comment[da]=Få adgang til internettet
Exec=/opt/google/chrome/google-chrome %U
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
X-Ayatana-Desktop-Shortcuts=NewWindow;NewIncognito

[NewWindow Shortcut Group]
Name=New Window
Name[ar]=نافذة جديدة
Name[da]=Nyt vindue
Exec=/opt/google/chrome/google-chrome
TargetEnvironment=Unity

[NewIncognito Shortcut Group]
Name=New Incognito Window
Name[ar]=نافذة جديدة للتصفح المتخفي
Name[da]=Nyt inkognitovindue
Exec=/opt/google/chrome/google-chrome --incognito
TargetEnvironment=Unity
EOF

mv /tmp/google-chrome.desktop /home/.skjult/Desktop
fi


# 4. Upgrade system

zenity --info --text="Systemet vil nu opdatere opstartsprogrammet."

dpkg-reconfigure grub-pc

zenity --question --text="Ønsker du at opgradere systemet og installere de nyeste sikkerhedsopdateringer?"

if [[  $? -eq 0 ]]
then 
    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y clean
fi 

# 5. Register in admin system

zenity --question  --text="Tilslut admin-systemet?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    register_new_bibos_client.sh
else
    zenity --info --text="Kør 'register_new_bibos_client.sh' hvis du vil tilslutte senere"
fi

if [[ -f /etc/lightdm/lightdm.conf.bibos ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    mv /etc/lightdm/lightdm.conf.bibos /etc/lightdm/lightdm.conf
fi

if [[ -f /etc/bibos/firstboot ]]
then
    # Add bibos started requirement to lightdm upstart script
    # TODO-CA: What is this? 
    grep "and started bibos" /etc/init/lightdm.conf > /dev/null
    if [ $? -ne 0 ]; then
        cat /etc/init/lightdm.conf | \
            perl -ne 's/and started dbus/and started dbus\n           and started bibos/;print' \
            > /tmp/lightdm.conf.tmp
        mv /tmp/lightdm.conf.tmp /etc/init/lightdm.conf
    fi
    rm /etc/bibos/firstboot
else
    zenity --warning --text="Dette er ikke en nyinstalleret BIBOS-maskine - opstarten ændres ikke.\n Lav en 'touch /etc/bibos/firstboot' og kør scriptet igen, hvis dette er en fejl."
fi


zenity --info --text="Installationen er afsluttet."
    
# Delete desktop file

DESKTOP_FILE=/home/superuser/Skrivebord/bibos-postinstall.desktop
if [[ -f $DESKTOP_FILE ]]
then
    rm $DESKTOP_FILE
fi
