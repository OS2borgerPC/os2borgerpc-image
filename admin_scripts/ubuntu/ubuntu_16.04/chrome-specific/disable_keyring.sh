#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    disable_keyring
#%
#% DESCRIPTION
#%    This is script sets Google Chromes default keyring.
#%
#================================================================
#- IMPLEMENTATION
#-    version         disable_keyring (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/24/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================


CHROME_KEYRING_FOLDER="/home/.skjult/.local/share/keyrings"

CHROME_KEYRING_DEFAULT="$CHROME_KEYRING_FOLDER/default"

CHROME_KEYRING="$CHROME_KEYRING_FOLDER/Standardnøglering.keyring"

if [ -f $CHROME_KEYRING ]
then
    rm $CHROME_KEYRING
    echo 'Old Keyring file found. It has been deleted.'
else
    mkdir $CHROME_KEYRING_FOLDER
fi

cat <<EOT >> "$CHROME_KEYRING_DEFAULT"
Standardnøglering
EOT

cat <<EOT >> "$CHROME_KEYRING"
[keyring]
display-name=Standardnøglering
ctime=1511526279
mtime=0
lock-on-idle=false
lock-after=false

[2]
item-type=0
display-name=Chrome Safe Storage
secret=3CWAlRR6ps0W8E0bZiu5aQ==
mtime=1511526290
ctime=1511526290

[2:attribute0]
name=application
type=string
value=chrome

[2:attribute1]
name=xdg:schema
type=string
value=chrome_libsecret_os_crypt_password_v2

[1]
item-type=0
display-name=Chrome Safe Storage Control
secret=The meaning of life
mtime=1511526279
ctime=1511526279

[1:attribute0]
name=explanation
type=string
value=Because of quirks in the gnome libsecret API, Chrome needs to store a dummy entry to guarantee that this keyring was properly unlocked. More details at http://crbug.com/660005.

[1:attribute1]
name=xdg:schema
type=string
value=_chrome_dummy_schema_for_unlocking
EOT