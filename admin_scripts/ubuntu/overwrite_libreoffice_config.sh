#!/usr/bin/env bash

# Overwrite the Libreoffice registrymodifications.xcu config with our own version.

mkdir -p /home/.skjult/.config/libreoffice/4/user/

cat << EOF > /home/.skjult/.config/libreoffice/4/user/registrymodifications.xcu
<?xml version="1.0" encoding="UTF-8"?>
<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="ShowTipOfTheDay" oor:op="fuse"><value>false</value></prop></item>
<item oor:path="/org.openoffice.Setup/Product"><prop oor:name="ooSetupLastVersion" oor:op="fuse"><value>6.4</value></prop></item>
</oor:items>
EOF

exit 0