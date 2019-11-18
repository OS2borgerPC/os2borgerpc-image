#!/bin/bash

cd /lib/live/mount/medium
reset
exec python3 -m os2borgerpc.installer \
        --image-dir "/lib/live/mount/medium/bibos-images/bibos_default" \
        "$@"
