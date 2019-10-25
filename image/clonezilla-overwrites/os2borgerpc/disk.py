import  re
from    enum        import Enum
from    math        import ceil, floor


size_expr = re.compile(r"^(?P<count>\d+)((?P<unit>[KMGTP])(iB)?)?$")
class Size(Enum):
    B = 1
    KiB = B * 1024
    MiB = KiB * 1024
    GiB = MiB * 1024
    TiB = GiB * 1024
    PiB = TiB * 1024

    @staticmethod
    def to_string(size):
        if size < Size.KiB.value:
            return "{0}B".format(size)
        elif size < Size.MiB.value:
            return "{0}KiB".format(size / Size.KiB.value)
        elif size < Size.GiB.value:
            return "{0}MiB".format(size / Size.MiB.value)
        elif size < Size.TiB.value:
            return "{0}GiB".format(size / Size.GiB.value)
        elif size < Size.PiB.value:
            return "{0}TiB".format(size / Size.TiB.value)
        else:
            return "{0}PiB".format(size / Size.PiB.value)

    @staticmethod
    def from_string(size):
        match = size_expr.match(size)
        if match:
            count = int(match.group("count"))
            unit = match.group("unit")
            if unit == "K":
                count *= Size.KiB.value
            if unit == "M":
                count *= Size.MiB.value
            elif unit == "G":
                count *= Size.GiB.value
            elif unit == "T":
                count *= Size.TiB.value
            elif unit == "P":
                count *= Size.PiB.value
            return count
        else:
            return None


class PartitionType(Enum):
    Linux = "0FC63DAF-8483-4772-8E79-3D69D8477DE4"
    Swap = "0657FD6D-A4AB-43C4-84E5-0933C84B4F4F"
    ESP = "C12A7328-F81F-11D2-BA4B-00A0C93EC93B"
    BIOS_BP = "21686148-6449-6E6F-744E-656564454649"


def smallest_multiple_leq_than(m, what):
    return int(ceil(what) / m) * m


class DiskAbstraction:
    def __init__(self, sector_size, sector_count, alignment=Size.MiB.value):
        self._sector_size = sector_size
        self._sector_count = sector_count
        self._alignment = alignment
        if alignment % sector_size:
            raise ValueError(
                    "alignment {0} is not evenly divisible by sector"
                    "size {1}".format(alignment, sector_size))
        self._quantum = int(alignment / sector_size)

        self._start_regions = []
        self._end_regions = []
        self._start = self._quantum
        # Disk layout trivia: GPT disks start with a MBR sector followed by
        # 33 sectors of GPT partitioning, and also *end* with 33 sectors of
        # backup GPT partitioning. 1MB alignment saves us from crashing into
        # the start of the disk, but we need to make sure we protect the end as
        # well
        self._end = sector_count - 33

    def blocks_to_quanta(self, blocks):
        return smallest_multiple_leq_than(self._quantum, blocks)

    def add_at_start(self, name, sector_count, kind):
        actual_size = self.blocks_to_quanta(sector_count)
        if self._start + actual_size > self._end:
            raise ValueError("new partition would be too big")
        self._start_regions.append((self._start, name, actual_size, kind))
        self._start += actual_size
    
    def add_at_end(self, name, sector_count, kind):
        actual_size = self.blocks_to_quanta(sector_count)
        # The end of the disk has a weird feature: an unaligned 33-sector
        # backup GPT. Make sure that alignment is preserved at the end despite
        # that
        unadjusted_end_offset = self._end - actual_size
        end_offset = \
            int(floor(unadjusted_end_offset / self._quantum) * self._quantum)
        actual_size = (self._end - end_offset)
        if self._end - actual_size < self._start:
            raise ValueError("new partition would be too big")
        self._end -= actual_size
        self._end_regions.insert(0, (self._end, name, actual_size, kind))

    @staticmethod
    def _append_sfdisk_line(script,
            start=None, name=None, size=None, kind=None, attrs=None):
        line = ""
        if start:
            line += "start={0} ".format(start)
        if name:
            line += "name=\"{0}\" ".format(name)
        if size:
            line += "size={0} ".format(size)
        if kind:
            line += "type=\"{0}\" ".format(kind.value)
        if attrs:
            line += "attrs={0} ".format(attrs)
        script.append(line)

    def make_sfdisk_script(self):
        script = ["label: gpt"]
        for start, name, size, kind in self._start_regions[:-1]:
            self._append_sfdisk_line(script, start, name, size, kind)
        try:
            start, name, size, kind = self._start_regions[-1]
            self._append_sfdisk_line(
                    script, start, name, self._end - start, kind,
                    attrs="LegacyBIOSBootable")
        except IndexError:
            pass
        for start, name, size, kind in self._end_regions:
            self._append_sfdisk_line(script, start, name, size, kind)
        return "\n".join(script)
