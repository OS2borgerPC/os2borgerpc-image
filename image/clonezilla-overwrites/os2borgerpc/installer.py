#!/usr/bin/env python3

from    os          import stat
import  re
from    sys         import exit, stderr
from    pathlib     import Path
import  argparse
import  subprocess

from    .disk       import Size, PartitionType, DiskAbstraction
from    .system     import get_lsblk, get_lsmem, get_sfdisk

args = None


lsblk = get_lsblk()
lsmem = get_lsmem()


def warn(*msgs):
    print(file=stderr, *msgs)


def die(code, *msgs):
    warn(*msgs)
    prompt("(press Enter to quit)")
    exit(code)


def valid_image_dir(path):
    image_path = Path(path)
    if not image_path.is_dir():
        raise argparse.ArgumentTypeError(
                "'{0}' is not a directory".format(path))
    partitions_file = image_path.joinpath("parts")
    if not partitions_file.exists():
        raise argparse.ArgumentTypeError(
                "'{0}' does not contain a partition list".format(path))            
    result = []
    for partition in partitions_file.open("rt").read().split():
        matched_files = list(image_path.glob(partition + ".*"))
        if not matched_files:
            raise argparse.ArgumentTypeError(
                    "partition '{0}' has no backing files".format(partition))
        else:
            result.append(partition)
    return (image_path, result)


def valid_device(device_name):
    """Checks that the named device exists in the list of block devices."""
    if not device_name in lsblk:
        raise argparse.ArgumentTypeError(
                "'{0}' is not the name of a system block device".format(
                        device_name))
    else:
        return (device_name, "/dev/{0}".format(device_name))


def file_device(device_name):
    return (device_name, device_name)


def valid_size(size):
    count = Size.from_string(size)
    if count is not None:
        return count
    else:
        raise argparse.ArgumentTypeError(
                "couldn't understand the size '{0}'".format(size))


def get_device_properties(device):
    """Returns a pair containing the sector size (in bytes) and sector count of
    the specified device."""
    device_name, device_path = device
    if device_name in lsblk:
        block = lsblk[device_name]
        sector_size = int(block["log-sec"])
        device_size = int(block["size"])
    elif Path(device_path).exists():
        sector_size = 512
        device_size = stat(device_name).st_size
    else:
        die(3, "no such device or file '{0}'".format(device_name))
    if device_size % sector_size:
        die(3, "device size {0} is not evenly divisible by sector size {1}".format(device_size, sector_size))
    return (sector_size, int(device_size / sector_size))


def glean_partition_properties(script_file, partition, *expressions):
    part_nr = None
    with script_file.open("rt") as fp:
        for line in fp:
            line = line.strip()
            if "=" in line:
                part_nr = (part_nr or 0) + 1
            if part_nr and partition in line:
                for label, expression in expressions:
                    match = expression.search(line)
                    if match:
                        yield (label, match.group("value"))
    return None


pp_size = ("size", re.compile(r"size[\s]*=[\s]*(?P<value>\d+)([\s,]|$)"))
pp_type = ("type",
        re.compile(r"type[\s]*=[\s]*(?P<value>[0-9A-F-]+)([\s,]|$)"))


def extract_single(iterator):
    result = list(iterator)
    if not len(result) == 1:
        raise ValueError("expected one item, got {0}".format(len(result)))
    else:
        return result[0]


def is_node_removable(node):
    if not node["rm"] or node["rm"] == "0":
        return False
    else:
        return True


def prompt(prefix="? ", intro=None):
    if not args.headless:
        try:
            return input(prefix)
        except EOFError:
            return ""
    else:
        return None


def main():
    parser = argparse.ArgumentParser()
    
    input_group = parser.add_argument_group("Input")
    input_group.add_argument(
            "--image-dir",
            type=valid_image_dir,
            required=True)

    installation_group = parser.add_argument_group("Installation")
    installation_group.add_argument(
            "--target-device",
            type=valid_device,
            required=False)
    installation_group.add_argument(
            "--swap",
            type=valid_size,
            required=False)
    installation_group.add_argument(
            "--target-device-file",
            type=file_device,
            help=argparse.SUPPRESS,
            dest="target_device",
            required=False)
    installation_group.add_argument(
            "--force-bootloader",
            choices=('efi', 'mbr', ),
            dest="bootloader",
            default=None)
    installation_group.add_argument(
            "--skip-partitioning",
            action="store_true")
    installation_group.add_argument(
            "--skip-restoring",
            action="store_true")
    installation_group.add_argument(
            "--skip-resizing",
            action="store_true")
    installation_group.add_argument(
            "--skip-bootloader",
            action="store_true")
    installation_group.add_argument(
            "--partclone-log",
            default="/var/log/partclone.log")
    installation_group.add_argument(
            "--headless",
            help="Never prompt for confirmation during the installation"
                    " process (DANGEROUS)",
            action="store_true")

    global args
    args = parser.parse_args()

    print("""
      ███                     ████                                              
   █  ███  █      █████████  ██████                                             
  ███ ███ ███    ███████████    ███                                             
 ████████ ████   ███████████   ███                                              
█████ ███ █████  ███     ██   ███                                               
████  ███  ████  ████        ██████                                             
████  ███   ████ ██████      ██████                                             
███         ████ █████████                                                      
███         ████  █████████   ██                                  ██████   █████
███         ████    ████████  ██                                  ███████ ██████
████        ████       █████  ██████  ████  ███ █████   ████  ███ ██  ██████  ██
████       ████  ██      ███  ██████ ██████ ██████████ ██████ ██████  █████     
██████    █████  ████   ████  ██  ██ ██  ██ ██  ██  ██ ██  ██ ██  █████████     
 █████████████  ████████████  ██  █████  ██ ██  ██  ██ ██████ ██  ██████ ███   █
  ███████████    ███████████  ██████ ██████ ██  ██████ ███    ██  ██     ███████
    ████████      ████████    ██████  ████  ██      ██  █████ ██  ██      ██████
                                                ██ ███                          
                                                 ████                           

OS2borgerPC installation environment v2.0.0
Copyright © 2019 Magenta ApS. Some rights reserved; see the licence for more
information.""")

    if not args.swap:
        print("swap size not specified, using RAM size")
        args.swap = 0
        for mem_block in lsmem:
            args.swap += int(mem_block["size"])
    print("swap size is {0} bytes".format(args.swap))

    if not args.target_device:
        if args.headless:
            die(1, "running in headless mode, but no target device was specified")
        candidates = \
            [node["name"] for node in lsblk.values()
                    if node["type"] == "disk" and not is_node_removable(node)]
        if len(candidates) == 0:
            warn("no candidate disks (out of {0})".format(len(lsblk)))
            for name, node in lsblk.items():
                warn(name, node["type"], node["rm"])
            die(2, "no candidate disks detected")
        elif len(candidates) == 1:
            target = candidates[0]
        else:
            for idx, device in enumerate(candidates):
                print("[{0}] {1}".format(idx, device))
            try:
                target = candidates[int(input("Select a device: "))]
            except (ValueError, IndexError):
                die(4, "not a valid device number")
        args.target_device = valid_device(target)

    sector_size, sector_count = get_device_properties(args.target_device)
    device_name, device_path = args.target_device

    print("Target device is {0}".format(args.target_device))
    subprocess.run(["fdisk", "--list", device_path])
    print("All data on the device will be destroyed.")
    user_ok = prompt("Are you sure you want to continue? [yN] ")
    if user_ok != "y" and user_ok != None:
        die(64, "user stopped the installation process")

    print("target device is {0}".format(device_name))
    print("sector size = {0}, count = {1}, total = {2}".format(
            Size.to_string(sector_size), sector_count,
            Size.to_string(sector_size * sector_count)))

    image_path, partitions = args.image_dir

    if not args.skip_partitioning:
        # Build a partition table for the saved partitions. We assume the last
        # of these is the main Ubuntu partition; this will have a flag set to
        # make it bootable with a legacy BIOS and will be resized to use as
        # much of the disk as possible. (The swap partition will be allocated
        # at the end of the disk.)
        nd = DiskAbstraction(sector_size, sector_count)

        # (On a GPT disk, GRUB needs an extra partition to store the so-called
        # "stage 1.5"; in the old days, this would have gone into the space
        # between the MBR and the first partition, but that's where the GPT
        # lives now.)
        nd.add_at_start(
                "bios_bp",
                Size.MiB.value / sector_size,
                PartitionType.BIOS_BP)

        # Restore the old partition table for the saved partitions
        partition_file = extract_single(image_path.glob("*-pt.sf"))
        for part in partitions:
            properties = dict(list(glean_partition_properties(
                    partition_file, part, pp_size, pp_type)))
            print(properties)
            size = int(properties["size"])
            nd.add_at_start(part, size, PartitionType(properties["type"]))

        # Instead of just appending a swap partition after the other
        # partitions, use DiskAbstraction.add_to_end to explicitly add it at
        # the end of the disk. This will mean that all extra space goes to the
        # last saved partition
        nd.add_at_end(
                "swap",
                int(args.swap / sector_size),
                PartitionType.Swap)

        # Generate a sfdisk(1)-format script that describes this partition
        # table and give it to sfdisk(1) to set up the partition table
        sfdisk_result = subprocess.run(["sfdisk", device_path],
                input=nd.make_sfdisk_script(),
                universal_newlines=True)
        if sfdisk_result.returncode is not 0:
            die(5, "sfdisk invocation failed")
        print("Partitioned disk.")

        # Now we've created our GPT disk, we need to make what's called a
        # "hybrid MBR": this contains details of up to four GPT partitions so
        # that machines with a traditional BIOS can still use them. We reflect
        # as many of the saved partitions as possible (but not the swap).
        hybrid_partitions = ":".join(
                [str(index) for index, _ in enumerate(partitions[:4], 1)])
        sgdisk_result = subprocess.run(
                ["sgdisk", "--hybrid", hybrid_partitions, device_path],
                universal_newlines=True)
        if sfdisk_result.returncode is not 0:
            die(6, "sfdisk invocation failed")
        print("Created hybrid GPT.")
    else:
        print("Skipped partitioning.")

    if not device_path.startswith("/dev/"):
        die(7, "everything after this point requires real devices")

    disk_structure = get_sfdisk(device_path)
    # (Hide GRUB's BIOS boot partition from the rest of the script -- nothing
    # else cares about it.)
    disk_partitions = disk_structure["partitions"][1:]

    if not args.skip_restoring:
        # Restore the saved partitions. Clonezilla stores partitions as a
        # number of gzipped streams, so we build a shell pipeline to
        # concatenate these together and feed them to partclone.restore(1) to
        # do the work
        for partition, node in zip(partitions, disk_partitions):
            matched_files = [
                    str(path) for path in image_path.glob(partition + ".*")]
            decompressor = subprocess.Popen(
                    ["gunzip", "-c", *matched_files],
                    stdout=subprocess.PIPE)
            partclone = subprocess.Popen(
                    ["partclone.restore", "-d", "-s", "-",
                            "-o", node["node"], "-L", args.partclone_log],
                    stdin=decompressor.stdout)
            decompressor.stdout.close()

            # Wait for Partclone to finish restoring this partition
            partclone.communicate()

            decompressor.poll()
            partclone.poll()
            if decompressor.returncode is not 0:
                die(8, "decompression failed")
            elif partclone.returncode is not 0:
                die(9, "partclone.restore failed")
        print("Restored partitions.")
    else:
        print("Skipped partition restoration.")

    if not args.skip_resizing:
        # Resize the last restored partition (-1 is the swap partition)
        e2fsck_result = subprocess.run(
                ["e2fsck", "-y", "-f", disk_partitions[-2]["node"]])
        if e2fsck_result.returncode is not 0:
            die(10, "checking root filesystem failed")
        print("Checked new root filesystem integrity.")

        resize2fs_result = subprocess.run(
                ["resize2fs", disk_partitions[-2]["node"]])
        if resize2fs_result.returncode is not 0:
            die(11, "resizing root filesystem failed")
        print("Resized new root filesystem.")
    else:
        print("Skipped resizing filesystem.")

    if not args.skip_bootloader:
        # We can only run grub-install(1) if the ultimate target filesystem is
        # mounted
        mount_result = subprocess.run(
                ["mount", disk_partitions[1]["node"], "/mnt"])
        if mount_result.returncode is not 0:
            die(10, "mounting new root filesystem failed")
        print("Mounted new root filesystem.")

        mount_result = subprocess.run(
                ["mount", disk_partitions[0]["node"], "/mnt/boot/efi"])
        if mount_result.returncode is not 0:
            die(12, "mounting EFI filesystem failed")
        print("Mounted new EFI filesystem.")

        print("Installing bootloader...")
        use_efi = (args.bootloader != "mbr" and (
                Path("/sys/firmware/efi").is_dir()
                or args.bootloader == "efi"))
        if use_efi:
            print("Installing EFI bootloader.")
            grub_install_result = subprocess.run(
                    ["grub-install",
                            "--target", "x86_64-efi",
                            "--root-directory", "/mnt",
                            device_path],
                    universal_newlines=True)
            if mount_result.returncode is not 0:
                die(13, "installation of EFI bootloader failed")
        else:
            print("Installing MBR bootloader.")
            grub_install_result = subprocess.run(
                    ["grub-install",
                            "--target", "i386-pc",
                            "--root-directory", "/mnt",
                            device_path],
                    universal_newlines=True)
            if mount_result.returncode is not 0:
                die(13, "installation of MBR bootloader failed")
        print("Installed bootloader.")

        subprocess.run(["umount", "/mnt/boot/efi"])
        subprocess.run(["umount", "/mnt"])
        print("Unmounted filesystems.")
    else:
        print("Skipped bootloader installation.")

    print("All done!")
    prompt("Press Enter to restart.")

    subprocess.run(["systemctl", "reboot", "-i"])

if __name__ == '__main__':
    main()
