"""
Script for OS2BorgerPC security system.
"""

from datetime import datetime
from datetime import date
from datetime import timedelta

__author__ = "Danni Als"
__copyright__ = "Copyright 2017, OS2BorgerPC"
__credits__ = ["Carsten Agger", "Dennis Borup Jakobsens"]
__license__ = "GPL"
__version__ = "0.0.1"
__maintainer__ = "Danni Als"
__email__ = "danni@magenta.dk"
__status__ = "Production"

# Search log from the end to a certain time
# Syslog is by Ubuntu default rotated daily


def read(sec, fname):
    """
    Method for reading an Ubuntu system log file.
    The file is red from behind until timestamp now - param sec
    :param sec: Number of seconds
    :param fname: File name
    :return: Data red from file
    """
    data = ""
    year = date.today().year

    with open(fname) as f:
        for line in reversed(f.readlines()):
            line = str(line.replace('\0', ''))
            date_object = datetime.strptime(str(year) + ' ' + line[:15],
                                            '%Y %b  %d %H:%M:%S')
            # Detect lines from within the last x seconds
            if (datetime.now() - timedelta(seconds=sec)) <= date_object:
                data = line + data

    return data
