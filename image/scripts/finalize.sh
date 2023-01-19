#!/usr/bin/env bash


printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

DIR=$(dirname "$(realpath "$0" )")

mkdir --parents /home/superuser/Skrivebord /home/superuser/.config
echo "yes" > /home/superuser/.config/gnome-initial-setup-done

chown -R superuser:superuser /home/superuser


cp "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/finalize/*.desktop "/home/superuser/Skrivebord"


# Setup cleanup script in systemd.
# Suppress output as it will try to reload/start the systemd service which will fail,
# as the script is usually being run on a running BorgerPC
"$DIR/systemd_policy_cleanup.sh" 1 > /dev/null

# The lack of a command after the preceding script triggers the exit 1 in prepare_os2borgerpc.sh
exit 0
