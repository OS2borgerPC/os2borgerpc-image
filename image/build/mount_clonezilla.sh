#!/bin/bash
CD="${1:-os2borgerpc_base_image.iso}" ; shift

# exit after any error:
set -e

DIRNAME=$( dirname "${BASH_SOURCE[0]}" )
DIR="$( cd "$DIRNAME" && pwd )"

if [ ! -f "$CD" ]; then
    CD="${DIR}/images/$CD"
fi

if [ ! -f "$CD" ]; then
    echo "No such file $CD"
    exit 1
fi

which mksquashfs

MNT_DIR=$( mktemp -d "${DIR}/os2borgerpc-clonezilla.XXXXXXXXXX" )
chmod 0775 "${MNT_DIR}"

# Make a link to the source CD we used
TMPDIR=$(dirname "$CD")
TMPDIR=$(cd "$TMPDIR" && pwd)
TMPFILE=$(basename $CD)
ln -s "${TMPDIR}/${TMPFILE}" "${MNT_DIR}/source-cd.iso"

CD_DIR="${MNT_DIR}/source-cd"
CD_RW_DIR="${MNT_DIR}/cd-changes"
CD_UNI_DIR="${MNT_DIR}/cd-unified"

RO_DIR="${MNT_DIR}/source-fs"
RW_DIR="${MNT_DIR}/fs-changes"
UNI_DIR="${MNT_DIR}/fs-unified"

for dir in "$MNT_DIR" "$CD_DIR" "$CD_RW_DIR" "$CD_UNI_DIR" \
    "$RO_DIR" "$RW_DIR" "$UNI_DIR"; do
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

# squashfs have issues between 64bit and 32bit systems, so avoid mounting it
# for now. We should be able to make all our changes at the CD level.
# mount compressed filesystem
# mnt "-t squashfs  -o ro,loop ${CD_DIR}/live/filesystem.squashfs" "$RO_DIR"

# create joined writable filesystem for the new CD
mnt "-t aufs -o br:${CD_RW_DIR}/=rw:${CD_DIR}/=ro none" "$CD_UNI_DIR"

# create joined writable filesystem for the new compressed squashfs filesystem
#mnt "-t aufs -o br:${RW_DIR}/=rw:${RO_DIR}/=ro none" "${UNI_DIR}"

# Reset traps since everything went ok
trap "" EXIT HUP TERM INT QUIT

echo ">>> Filesystem ready to be changed"
echo ">>>  cd: ${CD_UNI_DIR}"
