#!/usr/bin/env bash

DIRNAME=$(dirname "${BASH_SOURCE[0]}");
DIR=$( cd "$DIRNAME" && pwd )

DEST="$1"
if [ -z "$DEST" -o ! -f "$DEST/Clonezilla-Live-Version" ]; then
    DEST="${DEST}/cd-unified"
    if [ "$DEST" == "/cd-unified" -o ! -f "$DEST/Clonezilla-Live-Version" ]; then
        echo "You must specify a clonezilla filesystem as destination"
        exit 1;
    fi
fi

# Now do the deed (although don't do it as root unless we have to!)
cp -r "$DIR"/../clonezilla-overwrites/* "$DEST" || \
    sudo cp -r "$DIR"/../clonezilla/overwrites/* "$DEST"
