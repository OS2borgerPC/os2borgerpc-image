#!/usr/bin/env bash

SOURCE_DIR=$(dirname $(dirname $(realpath $0 )))

# Based on dconf_policy_desktop.sh
# Changes and locks the desktop background for all users on the
# system using a dconf lock.

POLICY="/etc/dconf/db/os2borgerpc.d/00-background"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/background"

if [ ! -d "`dirname "$POLICY"`" ]; then
    mkdir "`dirname "$POLICY"`"
fi
if [ ! -d "`dirname "$POLICY_LOCK"`" ]; then
    mkdir "`dirname "$POLICY_LOCK"`"
fi

# dconf does not, by default, require the use of a system database, so
# add one (called "os2borgerpc") to store our system-wide settings in
cat > "/etc/dconf/profile/user" <<END
user-db:user
system-db:os2borgerpc
END

OS2BORGERPC_BACKGROUND="$SOURCE_DIR"/graphics/production-green.png
# Copy the new desktop background into the appropriate folder
LOCAL_PATH="/usr/share/backgrounds/`basename "$OS2BORGERPC_BACKGROUND"`"
cp "$OS2BORGERPC_BACKGROUND" "$LOCAL_PATH"

cat > "$POLICY" <<END
[org/gnome/desktop/background]
picture-uri='file://$LOCAL_PATH'
picture-options='zoom'
END

# "dconf update" will only act if the content of the keyfile folder has
# changed: individual files changing are of no consequence. Force an update
# by changing the folder's modification timestamp
touch "`dirname "$POLICY"`"

# Tell the system that the values of the dconf keys we've just set can no
# longer be overridden by the user
cat > "$POLICY_LOCK" <<END
/org/gnome/desktop/background/picture-uri
/org/gnome/desktop/background/picture-options
END

