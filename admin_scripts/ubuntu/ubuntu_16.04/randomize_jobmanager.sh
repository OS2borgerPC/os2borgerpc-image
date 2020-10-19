#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    randomize_jobmanager args $(interval in minutes)
#%
#% DESCRIPTION
#%    This script sets the cron.d/os2borgerpc_jobmanager job to execute
#%    at a random startup time with a certain interval.
#%    So if the interval is 5 minutes, the jobmanager could run at
#%    1, 6, 11...56 every hour, instead of 0, 5, 10 ...55.
#%
#================================================================
#- IMPLEMENTATION
#-    version         randomize_jobmanager (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2018, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta-aps.dk
#-
#================================================================
#  HISTORY
#     2018/15/02 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

if [ $# -ne 1 ]
then
    echo "This job takes exactly one parameter."
    exit -1
fi

INTERVAL=$1

if [ $INTERVAL -gt 59 ]
then
    echo "Interval cannot be larger than 59."
    exit -1
fi

RANDOM_NUMBER=$((RANDOM%$INTERVAL+0))
CRON_COMMAND="$RANDOM_NUMBER,"

while [ $(($RANDOM_NUMBER+$INTERVAL)) -lt 60 ]
do
    RANDOM_NUMBER=$(($RANDOM_NUMBER+$INTERVAL))
    if [ $(($RANDOM_NUMBER+$INTERVAL)) -ge 60 ]
    then
        CRON_COMMAND="$CRON_COMMAND$RANDOM_NUMBER * * * * root /usr/local/bin/jobmanager"
    else
        CRON_COMMAND="$CRON_COMMAND$RANDOM_NUMBER,"
    fi
done
echo "$CRON_COMMAND"

CRON_PATH=/etc/cron.d/os2borgerpc-jobmanager

rm $CRON_PATH

cat <<EOT >> "$CRON_PATH"
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
$CRON_COMMAND
EOT