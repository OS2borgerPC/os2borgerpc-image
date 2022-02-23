#!/usr/bin/bash

# HOWTO build a CD image with the tools in this directory.

# Ressources:
# https://help.ubuntu.com/community/LiveCDCustomization
# https://wiki.ubuntu.com/UbiquityAutomation
# https://wiki.ubuntu.com/DesktopCDOptions
# https://help.ubuntu.com/lts/installation-guide/amd64/apbs01.html

ISO_PATH=$1
IMAGE_NAME=$2


if [[ -z $ISO_PATH || -z $IMAGE_NAME ]]
then
    echo "Usage: "$0" iso_file image_name"
    echo ""
    echo "iso_file must be a valid path to the ISO file to be remastered"
    echo "image_name is the name of the output image"
    echo ""
    exit 1
fi

set -ex

build/install_dependencies.sh

build/extract_iso.sh $ISO_PATH iso

# Unsquash and customize
sudo unsquashfs -f iso/casper/filesystem.squashfs

build/chroot_os2borgerpc.sh squashfs-root ./build/prepare_os2borgerpc.sh


# Regenerate manifest
build/chroot_os2borgerpc.sh squashfs-root build/create_manifest.sh > iso/casper/filesystem.manifest

cp iso/casper/filesystem.manifest iso/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' iso/casper/filesystem.manifest-desktop
sed -i '/casper/d' iso/casper/filesystem.manifest-desktop


# Build squashfs for the ISO

rm iso/casper/filesystem.squashfs
sudo mksquashfs squashfs-root iso/casper/filesystem.squashfs

# Calculate FS size
printf $(sudo du -sx --block-size=1 squashfs-root | cut -f1) > iso/casper/filesystem.size

# Overwrite preseed etc.
cp -r iso_overwrites/* iso/

# Recalculate MD5 sums.
cd iso
find -type f -print0 | sudo xargs -0 md5sum |  grep -v isolinux/boot.cat | grep -v md5sum | sudo tee md5sum.txt

# Make image
cd ..


xorriso -as mkisofs -r   -V "$IMAGE_NAME"   -o "$IMAGE_NAME".iso   -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot   -boot-load-size 4 -boot-info-table   -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot   -isohybrid-gpt-basdat -isohybrid-apm-hfsplus   -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso
