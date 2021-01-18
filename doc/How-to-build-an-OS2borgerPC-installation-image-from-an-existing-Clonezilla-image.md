# How to build an OS2borgerPC installation image from an existing
Clonezilla image

## Check out the code

```sh
git clone https://github.com/magenta-aps/bibos_image.git
cd bibos_image
```

## Download a stable Clonezilla live archive

The download link is
https://clonezilla.org/downloads/download.php?branch=stable. (These
instructions have worked with versions 2.5.6-22 and 2.6.0-37.)

## Unzip this archive to a new folder with the name of the image you
want to create

```sh
unzip path/to/clonezilla-live.zip -d OS2borgerPC_2019-02-13_M/
```

## Overwrite parts of Clonezilla with OS2borgerPC-specific configuration
files

```sh
./image/scripts/do_overwrite_clonezilla.sh OS2borgerPC_2019-02-13_M/
```

## Copy the OS2borgerPC hard disk image files to the `bibos-images/bibos_default/` directory

```sh
cp -r /path/to/image/* OS2borgerPC_2019-02-13_M/bibos-images/bibos_default/
```

## Create an ISO image from it

```sh
./image/scripts/make_bootable_iso.sh OS2borgerPC_2019-02-13_M
```

The resulting ISO image is a working boot disk, supporting both modern
EFI and traditional `isohybrid`-based boot processes, and can be written
directly to a USB stick or used as a CD-ROM image to set up a virtual
machine.

