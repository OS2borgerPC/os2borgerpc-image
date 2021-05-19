USER=user
AUTOSTART_DESKTOP_FILE_PATH=/home/$SHADOW/.config/autostart/gio-fix-desktop-file-permissions.desktop
SCRIPT_PATH=/usr/share/os2borgerpc/bin/gio-fix-desktop-file-permissions.sh

# Create the autostart directory, in case it doesn't exist
mkdir -p $(dirname $AUTOSTART_DESKTOP_FILE_PATH)

# Autorun file that simply launches the script below it after startup
cat << EOF > "$AUTOSTART_DESKTOP_FILE_PATH"
[Desktop Entry]
Type=Application
Name=Automatically allow launching of .desktop files on the desktop
Exec=$SCRIPT_PATH
Icon=system-run
X-GNOME-Autostart-enabled=true
EOF

# Script to activate programs on the desktop 
# (equivalent to right-click -> Allow Launching)
cat << EOF > "$SCRIPT_PATH"
for FILE in /home/$USER/Skrivebord/*.desktop; do
  gio set "\$FILE" metadata::trusted true
  # Can't make sense of this as it already has execute permissions, but it
  # won't work without it
  chmod u+x "\$FILE"
done
EOF

# Proper permissions on this file since it's in the home dir
# chown $USER:$USER "$AUTOSTART_DESKTOP_FILE_PATH"

# The regular user needs to be able to execute the script
chmod o+x "$SCRIPT_PATH"
