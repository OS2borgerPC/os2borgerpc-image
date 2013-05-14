#/bin/bash

MNT_DIR=$1; shift

if [ "$MNT_DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

MNT_DIR=${MNT_DIR%/}

CD_DIR="${MNT_DIR}/source-cd"
CD_RW_DIR="${MNT_DIR}/cd-changes"
CD_UNI_DIR="${MNT_DIR}/cd-unified"

RO_DIR="${MNT_DIR}/source-fs"
RW_DIR="${MNT_DIR}/fs-changes"
UNI_DIR="${MNT_DIR}/fs-unified"

for dir in "$MNT_DIR" "$CD_DIR" "$CD_RW_DIR" "$CD_UNI_DIR" \
    "$RO_DIR" "$RW_DIR" "$UNI_DIR"; do
    if [ ! -d "$dir" ]; then
        echo "$dir does not exist, exiting"
        exit 1
    fi
done

CD="${MNT_DIR}/source-cd.iso"
if [ ! -e "$CD" ]; then
    echo "$CD does not exist, exiting"
    exit 1
fi

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

# mount compressed filesystem
#mnt "-t squashfs ${CD_DIR}/live/filesystem.squashfs -o ro,loop" "$RO_DIR"

# create joined writable filesystem for the new CD
mnt "-t aufs -o br:${CD_RW_DIR}/=rw:${CD_DIR}/=ro none" "$CD_UNI_DIR"

# create joined writable filesystem for the new compressed squashfs filesystem
#mnt "-t aufs -o br:${RW_DIR}/=rw:${RO_DIR}/=ro none" "${UNI_DIR}"

# Reset traps since everything went ok
trap "" EXIT HUP TERM INT QUIT

echo ">>> Filesystems ready to be changed"
echo ">>>  cd: ${CD_UNI_DIR}"
#echo ">>>  clonezilla-filesystem: ${CD_UNI_DIR}"
