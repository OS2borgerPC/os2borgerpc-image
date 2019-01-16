# How to build an OS2borgerPC installation USB stick from an existing Clonezilla image

## Check out the code

```sh
git clone https://github.com/magenta-aps/bibos_image.git
cd bibos_image
```

## Download a stable Clonezilla live archive

The download link is https://clonezilla.org/downloads/download.php?branch=stable. (These instructions have worked with versions 2.5.6-22 and 2.6.0-37.)

## Unzip this archive to the root directory of an empty USB stick formatted with the FAT filesystem

```sh
unzip path/to/clonezilla-live.zip -d /path/to/usb/stick
```

## Overwrite parts of Clonezilla with OS2borgerPC-specific configuration files

```sh
./image/scripts/do_overwrite_clonezilla.sh /path/to/usb/stick
```

## Copy the OS2borgerPC hard disk image to the USB stick's `bibos-images/bibos_default/` directory

```sh
cp -r /path/to/image/* /path/to/usb/stick/bibos-images/bibos_default/
```

## Make the USB stick bootable

```sh
cd /path/to/usb/stick
bash ./utils/linux/makeboot.sh /dev/usb-stick-partition
```

Follow the prompts given by `makeboot.sh`. (If any required packages are missing, the script will prompt you to install them.)

And that's it -- the USB stick should be able to boot a computer in either UEFI or legacy mode, and will present the same options in either case.
