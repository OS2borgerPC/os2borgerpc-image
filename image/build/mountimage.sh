#/bin/bash
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

MNT_DIR="${DIR}/mnt"
CD_DIR="${MNT_DIR}/source-cd"
RO_IMAGE="${MNT_DIR}/fs-readonly"
RW_IMAGE="${MNT_DIR}/fs-changes"
UNIFIED_IMAGE="${MNT_DIR}/fs-unified"

for dir in "$MNT_DIR" "$CD_DIR" "$RO_IMAGE" "$RW_IMAGE" "$UNIFIED_IMAGE"; do
    if [ ! -d "$dir" ]; then
        echo "$dir does not exist, creating it..."
        mkdir "$dir"
    fi
done

exit

which mksquashfs tempfile sed

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
mnt "-t auto $CD -o loop,ro" $CD_DIR

# mount compressed filesystem
mnt "-t squashfs ${CD_DIR}/live/filesystem.squashfs -o ro,loop" 

# create joined writable filesystem for the new CD
mnt "-t aufs -o br:$WDIR/cd-w=rw:$WDIR/cd=ro none" cd-u cd-w

# create joined writable filesystem for the new compressed squashfs filesystem
mnt "-t aufs -o br:$WDIR/sq-w=rw:$WDIR/sq=ro none" sq-u sq-w

echo ">>> Filesystem mounted in ${UNIFIED_DIR} and ready to be changed"

# The trap ... callbacks will unmount everything.