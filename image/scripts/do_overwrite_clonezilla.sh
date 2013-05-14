#!/usr/bin/env bash

DIRNAME=$(dirname "${BASH_SOURCE[0]}");
DIR=$( cd "$DIRNAME" && pwd )

DEST="$1"
if [ -z $DEST -o ! -f "$DEST/Clonezilla-Live-Version" ]; then
    echo "You must specify a clonezilla filesystem as destination"
    exit 1;
fi


# Now do the deed
cp -r $DIR/../clonezilla-overwrites/* $DEST
