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

which mksquashfs

MNT_DIR=$( mktemp -d "${DIR}/bibos-clonezilla.XXXXXXXXXX" )
chmod 0775 "${MNT_DIR}"

# Make a link to the source CD we used
ln -s "${CD}" "${MNT_DIR}/source-cd.iso"

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

# mount compressed filesystem
mnt "-t squashfs ${CD_DIR}/live/filesystem.squashfs -o ro,loop" "$RO_DIR"

# create joined writable filesystem for the new CD
mnt "-t aufs -o br:${CD_RW_DIR}/=rw:${CD_DIR}/=ro none" "$CD_UNI_DIR"

# create joined writable filesystem for the new compressed squashfs filesystem
mnt "-t aufs -o br:${RW_DIR}/=rw:${RO_DIR}/=ro none" "${UNI_DIR}"

# Reset traps since everything went ok
trap "" EXIT HUP TERM INT QUIT

echo ">>> Filesystems ready to be changed"
echo ">>>  cd: ${CD_UNI_DIR}"
echo ">>>  clonezilla-filesystem: ${UNI_DIR}"
