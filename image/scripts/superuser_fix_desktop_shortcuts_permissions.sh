#! /usr/bin/env sh

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

set -x

USR=superuser

mkdir --parents /home/$USR/.config/autostart
DESKTOP_FILE=/home/$USR/.config/autostart/gio_fix_desktop_file_permissions_superuser.desktop
SCRIPT=/home/$USR/gio_fix_desktop_file_permissions_superuser.sh

cat <<- EOF > $DESKTOP_FILE
	[Desktop Entry]
	Type=Application
	Name=Automatically allow launching of .desktop files on the desktop
	Exec=$SCRIPT
	Icon=system-run
	X-GNOME-Autostart-enabled=true
EOF

cat <<- EOF > $SCRIPT
	#! /usr/bin/env sh

	for FILE in /home/$USR/Skrivebord/*.desktop; do
	  gio set "\$FILE" metadata::trusted true
	  # Can't make sense of this as it already has execute permissions, but it won't work without it
	  chmod u+x "\$FILE"
	done

	# Cleanup and delete itself and the desktop file launching it
	rm $DESKTOP_FILE $SCRIPT
EOF

# Fix permissions
chown superuser:superuser $DESKTOP_FILE $SCRIPT
chmod u+x $DESKTOP_FILE $SCRIPT
