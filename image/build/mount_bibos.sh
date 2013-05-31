#!/bin/bash
CD="${1:-bibos_base_image.iso}" ; shift

# exit after any error:
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f "$CD" ]; then
    CD="${DIR}/images/$CD"
fi

if [ ! -f "$CD" ]; then
    echo "No such file $CD"
    exit 1
fi

which mksquashfs partclone.restore

MNT_DIR=$( mktemp -d "${DIR}/bibos-image.XXXXXXXXXX" )
chmod 0775 "${MNT_DIR}"

# Make a link to the source CD we used
ln -s "${CD}" "${MNT_DIR}/source-cd.iso"

CD_DIR="${MNT_DIR}/source-cd"
CD_RW_DIR="${MNT_DIR}/cd-changes"
CD_UNI_DIR="${MNT_DIR}/cd-unified"

HD_IMAGE="${MNT_DIR}/hd_loopback_image.img"
FS_DIR="${MNT_DIR}/filesystem"

for dir in "$MNT_DIR" "$CD_DIR" "$CD_RW_DIR" "$CD_UNI_DIR" "$FS_DIR"; do
    if [ ! -d "$dir" ]; then
        mkdir "$dir"
    fi
done

EXIT=""
function addExit {
    EXIT="$@ ; $EXIT"
    trap "$EXIT" EXIT HUP TERM INT QUIT
}
function mnt {
    local margs="$1" ; shift
    local mp="$1"
    mount -v $margs "$mp"
    addExit "umount -v $mp"
}

# mount the CD image
mnt "-t iso9660 $CD -o loop,ro" $CD_DIR

echo "Generating HD loopback image"
cat ${CD_DIR}/bibos-images/bibos_default/sda1.ext4-ptcl-img.gz.a* | \
    gzip -d -c | \
    partclone.restore -C -s - -O "${HD_IMAGE}" --restore_raw_file

echo "Mounting filesystems"
mnt "-t ext4 ${HD_IMAGE} -o loop" "$FS_DIR"

# create joined writable filesystem for the new CD
mnt "-t aufs -o br:${CD_RW_DIR}/=rw:${CD_DIR}/=ro none" "$CD_UNI_DIR"

# Reset traps since everything went ok
trap "" EXIT HUP TERM INT QUIT

echo ">>> Filesystems ready to be changed"
echo ">>>  cd: ${CD_UNI_DIR}"
echo ">>>  bibos-filesystem: ${FS_DIR}"
