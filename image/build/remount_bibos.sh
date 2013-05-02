#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

FS_DIR="${DIR}/filesystem"
CD_UNI_DIR="${DIR}/cd-unified"
CD_RO_DIR="${DIR}/source-cd"
CD_RW_DIR="${DIR}/cd-changes"

for dir in "$FS_DIR" "$CD_UNI_DIR" "$CD_RO_DIR" "$CD_RW_DIR"; do
    if [ ! -d "$dir" ]; then
        echo "$dir does not exist, exiting"
        exit 1
    fi
done

CD_ISO="${DIR}/source-cd.iso"
HD_IMG="${DIR}/hd_loopback_image.img"

for file in "$CD_ISO" "$HD_IMG"; do
    if [ ! -e "$file" ]; then
        echo "$file does not exist, exiting"
        exit 1
    fi
done

# Mount CD
mount -v -t iso9660 "${CD_ISO}" -o loop,ro "${CD_RO_DIR}"

# Mount unified CD filesystem
mount -v -t aufs -o "br:${CD_RW_DIR}/=rw:${CD_RO_DIR}/=ro" none \
    "$CD_UNI_DIR"

# Mount filesystem
mount -v -t ext4 "${HD_IMG}" -o loop "$FS_DIR"
