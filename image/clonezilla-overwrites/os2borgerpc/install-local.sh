#!/bin/bash

cd /run/live/medium
reset
exec python3 -m os2borgerpc.installer \
        --image-dir "/run/live/medium/os2borgerpc-images/os2borgerpc_default" \
        "$@"
