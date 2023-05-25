#!/usr/bin/env bash

printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

DIR=$(dirname "$(realpath "$0" )")

# Setup cleanup script in systemd.
# Suppress output as it will try to reload/start the systemd service which will fail,
# as the script is usually being run on a running BorgerPC
"$DIR/systemd_policy_cleanup.sh" 1 > /dev/null

# Enable FSCK automatic fixes
sed --in-place "s/FSCKFIX=no/FSCKFIX=yes/" /lib/init/vars.sh
