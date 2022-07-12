#!/usr/bin/bash

# Ressources:
# https://help.ubuntu.com/community/LiveCDCustomization
# https://wiki.ubuntu.com/UbiquityAutomation
# https://wiki.ubuntu.com/DesktopCDOptions
# https://help.ubuntu.com/lts/installation-guide/amd64/apbs01.html

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

ISO_PATH=$1
IMAGE_NAME=$2
if [ "$3" = "--clean" ]; then CLEAN_BUILD=1; fi


if [[ -z $ISO_PATH || -z $IMAGE_NAME ]]
then
    echo "Usage: "$0" iso_file image_name [--clean]"
    echo ""
    echo "iso_file must be a valid path to the ISO file to be remastered"
    echo "image_name is the name of the output image"
    echo "clean: pass --clean to first delete temp build files, e.g. from within iso/"
    echo ""
    exit 1
fi

IMAGE_MOUNT_POINT="squashfs-root/mnt"
TMP_MOUNT_POINT="squashfs-root/tmp"

unmount_cleanup() {
    sudo umount $TMP_MOUNT_POINT $IMAGE_MOUNT_POINT || true
}

figlet "Building OS2borgerPC"

set -ex

if [ "$CLEAN_BUILD" ]
then
    # In case it was cancelled prematurely and /tmp is still bind-mounted to squashfs-root/tmp
    unmount_cleanup
    sudo rm -rf iso/.disk/ iso/* squashfs squashfs-root/ /tmp/build_installed_packages_list.txt /tmp/scripts_installed_packages_list.txt /root/os2borgerpc_install_log.txt /tmp/os2borgerpc_upgrade_log.txt
fi

build/install_dependencies.sh > /dev/null

build/extract_iso.sh "$ISO_PATH" iso

# Unsquash and customize
sudo unsquashfs -f iso/casper/filesystem.squashfs > /dev/null

# Mounting the build files into the chroot
sudo mount --bind . $IMAGE_MOUNT_POINT
# Mounting in our own tmp into the chroot so we retain access to the log files written from within it
sudo mount --bind /tmp $TMP_MOUNT_POINT

figlet "About to enter chroot"

build/chroot_os2borgerpc.sh squashfs-root ./build/prepare_os2borgerpc.sh


# Regenerate manifest
build/chroot_os2borgerpc.sh squashfs-root build/create_manifest.sh > iso/casper/filesystem.manifest
figlet "Exiting chroot"

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
md5sum casper/filesystem.squashfs > md5sum.txt
cd ..

# Cleanup and unmount our tmp from squashfs-root
unmount_cleanup

# Make image

xorriso -as mkisofs -r   -V "$IMAGE_NAME"   -o "$IMAGE_NAME".iso   -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot   -boot-load-size 4 -boot-info-table   -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot   -isohybrid-gpt-basdat -isohybrid-apm-hfsplus   -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso
