#!/usr/bin/env bash

LIBREOFFICE_CONFIG_FILE=/home/user/.config/libreoffice/4/user/registrymodifications.xcu

OLD_TIP_OF_THE_DAY_LINE=$(grep "ShowTipOfTheDay" $LIBREOFFICE_CONFIG_FILE)
NEW_TIP_OF_THE_DAY_LINE=${OLD_TIP_OF_THE_DAY_LINE/<value>true<\/value>/<value>false<\/value>}

sed -i "s+$OLD_TIP_OF_THE_DAY_LINE+$NEW_TIP_OF_THE_DAY_LINE+" $LIBREOFFICE_CONFIG_FILE

CURRENT_LIBREOFFICE_VERSION=$(libreoffice --version | cut -d ' ' -f 2 -s)

OLD_SETUP_LAST_VERSION_LINE=$(grep "ooSetupLastVersion" $LIBREOFFICE_CONFIG_FILE)

NEW_SETUP_LAST_VERSION_LINE="<item oor:path=\"/org.openoffice.Setup/Product\"><prop oor:name=\"ooSetupLastVersion\" oor:op=\"fuse\"><value>$CURRENT_LIBREOFFICE_VERSION</value></prop></item>"

sed -i "s+$OLD_SETUP_LAST_VERSION_LINE+$NEW_SETUP_LAST_VERSION_LINE+" $LIBREOFFICE_CONFIG_FILE