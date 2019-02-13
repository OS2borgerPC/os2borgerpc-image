#!/bin/sh

ead() {
    echo "$@" && "$@"
}

usage() {
    echo "Usage: $0 DIRECTORY [VOLUME-LABEL]"
    exit 1
}

IMAGE_DIR="${1%%/}"
if [ "$IMAGE_DIR" = "" ]; then
    usage
fi
if [ "$2" != "" ]; then
    IMAGE_LABEL="$2"
else
    IMAGE_LABEL="$IMAGE_DIR"
fi

if [ ! -d "$IMAGE_DIR" ]; then
    echo "$0: the directory \"$IMAGE_DIR\" does not exist" 1>&2
    exit 1
else
    # -JR makes the image have Windows- and POSIX-compatible metadata to make
    # the filesystem behave more normally
    ead genisoimage \
        -o "$IMAGE_LABEL.iso" -V "$IMAGE_LABEL" \
        -iso-level 4 -JR \
        -c syslinux/boot.cat -b syslinux/isolinux.bin \
            -no-emul-boot -boot-load-size 4 -boot-info-table \
        -eltorito-alt-boot \
            -e boot/grub/efi.img -no-emul-boot \
        "$IMAGE_DIR/" && ead isohybrid "$IMAGE_LABEL.iso"
fi
