#!/usr/bin/bash

# Ressources:
# https://help.ubuntu.com/community/LiveCDCustomization
# https://wiki.ubuntu.com/UbiquityAutomation
# https://wiki.ubuntu.com/DesktopCDOptions
# https://help.ubuntu.com/lts/installation-guide/amd64/apbs01.html

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

# Handle optional arguments
COUNT=0
if [ "$1" = "--clean" ] || [ "$2" = "--clean" ]; then
  CLEAN_BUILD=true
  COUNT=$((COUNT+1))
fi

if [ "$1" == "--skip-build-deps" ] || [ "$2" == "--skip-build-deps" ]; then
  SKIP_BUILD_DEPS=true
  COUNT=$((COUNT+1))
fi
# Remove the optional arguments if there were any, so we only have the required ones left
shift $COUNT

ISO_PATH=$1
IMAGE_NAME=$2


if [[ -z $ISO_PATH || -z $IMAGE_NAME ]]
then
    echo "Usage: "$0"  [--clean] [--skip-build-deps] iso_file image_name"
    echo ""
    echo "--clean: pass this argument to first delete temp build files, e.g. from within iso/"
    echo "--skip-build-deps: pass this argument to skip installing build dependencies. Useful if testing on a non-debian-system, ie. without apt"
    echo "iso_file must be a valid path to the ISO file to be remastered"
    echo "image_name is the name of the output image"
    echo ""
    exit 1
fi

BUILD_FILES_COPY_DESTINATION="squashfs-root/mnt"
TMP_MOUNT_POINT="squashfs-root/tmp"

unmount_cleanup() {
    sudo umount $TMP_MOUNT_POINT || true
}

figlet "Building OS2borgerPC"

echo "Ignore errors about zsys daemon in the log output"

set -ex

if [ "$CLEAN_BUILD" ]
then
    # In case it was cancelled prematurely and /tmp is still bind-mounted to squashfs-root/tmp
    unmount_cleanup
    sudo chattr -f -i squashfs-root/var/lib/lightdm/.cache/unity-greeter/state || true
    sudo rm -rf iso/.disk/ iso/* squashfs squashfs-root/ /tmp/build_installed_packages_list.txt /tmp/scripts_installed_packages_list.txt /tmp/os2borgerpc_install_log.txt /tmp/os2borgerpc_upgrade_log.txt boot_hybrid.img ubuntu22-desktop-amd64.efi
fi

if [ ! "$SKIP_BUILD_DEPS" ]
then
    build/install_dependencies.sh > /dev/null
fi

build/extract_iso.sh "$ISO_PATH" iso

# Unsquash and customize
sudo unsquashfs -f iso/casper/filesystem.squashfs > /dev/null

# Mounting in our own tmp into the chroot so we retain access to the log files written from within it
# This will fail in the pipeline due to a permissions error, but it will work locally
sudo mount --bind /tmp $TMP_MOUNT_POINT || true

echo "Copying in image building files before chrooting"
sudo rsync -r --exclude squashfs-root --exclude image/*.iso --exclude .git --exclude image/iso ../ $BUILD_FILES_COPY_DESTINATION

figlet "About to enter chroot"

build/chroot_os2borgerpc.sh squashfs-root ./build/prepare_os2borgerpc.sh


# Regenerate manifest
build/chroot_os2borgerpc.sh squashfs-root build/create_manifest.sh > iso/casper/filesystem.manifest
figlet "Exiting chroot"

cp iso/casper/filesystem.manifest iso/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' iso/casper/filesystem.manifest-desktop
sed -i '/casper/d' iso/casper/filesystem.manifest-desktop


# Build squashfs for the ISO

# First delete the image building files from squashfs again
sudo rm -rf $BUILD_FILES_COPY_DESTINATION/* squashfs-root/*.sh

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

mbr="boot_hybrid.img"

efi="ubuntu22-desktop-amd64.efi"

# Extract the MBR template

dd if="$ISO_PATH" bs=1 count=446 of=$mbr

# Extract EFI partition image

skip=$(/sbin/fdisk -l "$ISO_PATH" | grep -F '.iso2 ' | awk '{print $2}')

size=$(/sbin/fdisk -l "$ISO_PATH" | grep -F '.iso2 ' | awk '{print $4}')

dd if="$ISO_PATH" bs=512 skip="$skip" count="$size" of=$efi

# Make image

xorriso -as mkisofs -r   -V "$IMAGE_NAME" -o "$IMAGE_NAME".iso   -J -joliet-long -l -iso-level 3 -partition_offset 16 --grub2-mbr $mbr --mbr-force-bootable -append_partition 2 0xEF $efi -appended_part_as_gpt -c boot.catalog -b boot/grub/i386-pc/eltorito.img -no-emul-boot   -boot-load-size 4 -boot-info-table --grub2-boot-info  -eltorito-alt-boot -e '--interval:appended_partition_2:all::' -no-emul-boot iso
