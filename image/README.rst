# Technical information about the image building process

## Script execution order

From earliest to latest.

Relevant when determining where something should be inserted, and to know what has been done/exists at a given stage.

build_os2borgerpc_image.sh
-> build/install_dependencies.sh
-> build/extract_iso.sh
-> build/chroot_os2borgerpc.sh squashfs-root ./build/prepare_os2borgerpc.sh
  -> /mnt/image/scripts/os2borgerpc_setup.sh
    -> scripts/do_overwrite.sh
    -> scripts/install_dependencies.sh
  -> /mnt/image/scripts/finalize.sh
-> build/chroot_os2borgerpc.sh squashfs-root build/create_manifest.sh > iso/casper/filesystem.manifest
