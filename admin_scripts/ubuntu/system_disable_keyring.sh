#!/usr/bin/env bash

export KEYRING_DIR=/home/.skjult/.local/share/keyrings
mkdir -p $KEYRING_DIR

cat << EOF >  $KEYRING_DIR/default
Standardnøglering
EOF

cat << EOF > $KEYRING_DIR/Standardnøglering.keyring

[keyring]
display-name=Standardnøglering
ctime=1618992405
mtime=0
lock-on-idle=false
lock-after=false

[2]
item-type=0
display-name=Chrome Safe Storage
secret=NpupNWtK2D1cVka/ufDpkQ==
mtime=1618992406
ctime=1618992405

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
mtime=1618992405
ctime=1618992405

[1:attribute0]
name=explanation
type=string
value=Because of quirks in the gnome libsecret API, Chrome needs to store a dummy entry to guarantee that this keyring was properly unlocked. More details at http://crbug.com/660005.

[1:attribute1]
name=xdg:schema
type=string
value=_chrome_dummy_schema_for_unlocking

EOF

chmod og-r $KEYRING_DIR/Standardnøglering.keyring
