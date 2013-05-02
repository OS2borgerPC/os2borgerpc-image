#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

DIR1="${DIR}/fs-unified"
DIR2="${DIR}/source-fs"
DIR3="${DIR}/cd-unified"
DIR4="${DIR}/source-cd"


for dir in "$DIR1" "$DIR2" "$DIR3" "$DIR4"; do
    if [ ! -d "$dir" ]; then
        echo "$dir does not exist, exiting"
        exit 1
    fi
done

for dir in "$DIR1" "$DIR2" "$DIR3" "$DIR4"; do
    echo "Unmounting $dir"
    umount -v "$dir"
done
