#!/usr/bin/env bash
set -e 

# Needed to run firefox with no interface
echo "Installing xvfb"
apt-get install xvfb -y

# Starting display
# Kill if started
echo "Collecting old xvfb pids"
OLD_PID=$(pidof /usr/bin/Xvfb || true)
if [ ! -z "$OLD_PID" ]
then	
	kill -KILL $OLD_PID
fi

# Make sure that no instance of firefox is running
echo "Killing firefox processes"
FIREFOX_PIDS=$(pidof firefox || true)
if [ ! -z "$FIREFOX_PIDS" ]
then
	killall firefox
fi

echo "Starting new xvfb process"
#sudo -u user Xvfb-run firefox &
#THE_PID=$!
# Xvfb :19 -screen 0 1024x768x16 &
# THE_PID=$!
export DISPLAY=:0

# Install pipelight and enable silverlight
echo "Adding pipelight ppa"
add-apt-repository ppa:pipelight/stable -y
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends pipelight-multi -y
pipelight-plugin --update 
pipelight-plugin --accept --enable silverlight

# User dir and .skjult dir
USER_MOZILLA_DIR=/home/user/.mozilla/firefox/e1362422.default
MOZILLA_DIR=/home/.skjult/.mozilla/firefox/e1362422.default

# Disable load flash only
echo "Disabling load flash only for ff"
USERPREF="user_pref(\"plugin.load_flash_only\", false);"

if grep -Fxq "$USERPREF" $MOZILLA_DIR/prefs.js
then
    	echo 'User pref already exists.'
else
	echo "$USERPREF" >> $MOZILLA_DIR/prefs.js
fi

cp $MOZILLA_DIR/prefs.js $USER_MOZILLA_DIR/

# Starting firefox instance for user and waits until wine with silverlight is installed.
# When installed firefox instance is closed and folder created is stored in .skjult
sudo -u user -H Xvfb-run firefox | while read line; do test "$line" = "All done, no errors." && sudo killall firefox; done

# Clean up - Make sure firefox is closed
echo "Clean up. Stopping firefox"
FIREFOX_PIDS_CLEANUP=$(pidof firefox || true)
if [ ! -z "$FIREFOX_PIDS_CLEANUP" ]
then
	killall firefox
fi
# Shut down display
#echo "Stopping xvfb process"
#kill -KILL $THE_PID

# Enable plugin for firefox
# TODO: Maybe this should be stored in .skjult as well.
echo "Enabling pipelight plugin"
pipelight-plugin --create-mozilla-plugins

# Copy the created wine folder to .skjult so we preserve it for next login
cp -R /home/user/.wine-pipelight /home/.skjult

cp $USER_MOZILLA_DIR/pluginreg.dat $MOZILLA_DIR/pluginreg.dat






