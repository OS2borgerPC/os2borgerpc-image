from    json        import loads
import  subprocess


def get_lsblk():
    """Returns a description of all block devices in the system."""
    result = subprocess.run(
            ["lsblk", "--json", "--output-all", "--bytes"],
            stdout=subprocess.PIPE)
    return {value["name"]: value
            for value in loads(result.stdout.decode("ascii"))["blockdevices"]}


def get_lsmem():
    result = subprocess.run(
            ["lsmem", "--json", "--bytes"],
            stdout=subprocess.PIPE)
    return loads(result.stdout.decode("ascii"))["memory"]


def get_sfdisk(device_path):
    result = subprocess.run(
            ["sfdisk", "--json", device_path],
            stdout=subprocess.PIPE)
    return loads(result.stdout.decode("ascii"))["partitiontable"]
