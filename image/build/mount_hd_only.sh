#!/bin/bash
IMAGE_DIR="${1}" ; shift

if [ "$IMAGE_DIR" == "" ]; then
    echo "You must specify a directory containing a clonezilla image."
    exit 1
fi

# exit after any error:
set -e

DIRNAME=$( dirname "${BASH_SOURCE[0]}")
DIR="$( cd "$DIRNAME" && pwd )"

if [ ! -d "$IMAGE_DIR" -o ! -f "${IMAGE_DIR}/sda1.ext4-ptcl-img.gz.aa" ]; then
    echo "$IMAGE_DIR does not seem to be a OS2borgerPC hd image"
    exit 1
fi

which partclone.restore

MNT_DIR=$( mktemp -d "${DIR}/os2borgerpc-hd-image.XXXXXXXXXX" )
chmod 0775 "${MNT_DIR}"

HD_IMAGE="${MNT_DIR}/hd_loopback_image.img"
FS_DIR="${MNT_DIR}/filesystem"

for dir in "$FS_DIR"; do
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

echo "Generating HD loopback image"
cat ${IMAGE_DIR}/sda1.ext4-ptcl-img.gz.a* | \
    gzip -d -c | \
    partclone.restore -C -s - -O "${HD_IMAGE}" --restore_raw_file

echo "Mounting filesystems"
mnt "-t ext4 ${HD_IMAGE} -o loop" "$FS_DIR"

# Reset traps since everything went ok
trap "" EXIT HUP TERM INT QUIT

echo ">>> Filesystems ready to be changed"
echo ">>>  os2borgerpc-filesystem: ${FS_DIR}"
