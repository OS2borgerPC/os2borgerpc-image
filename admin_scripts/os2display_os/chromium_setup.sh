#!/bin/bash
# Make Chromium  autostart and set it up with OS2Display.

# Initialize parameters

TIME=$1
URL=$2

# Setup Chromium user
useradd chrome -m -p 12345 -s /bin/bash -U
chfn -f Chrome chrome

# Autologin default user

mkdir -p /etc/systemd/system/getty@tty1.service.d

cat << EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin chrome %I $TERM
Type=idle
EOF

cat << EOF > /home/chrome/.xinitrc
#!/bin/sh

sleep $TIME

exec chromium-browser --kiosk $URL --full-screen --password-store=basic --autoplay-policy=no-user-gesture-required --disable-translate --enable-offline-auto-reload
EOF


echo "startx" >> /home/chrome/.profile
