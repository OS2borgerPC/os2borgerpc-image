#!/usr/bin/env python

"""
Script for OS2BorgerPC security system.
"""

from datetime import datetime

__author__ = "Danni Als"
__copyright__ = "Copyright 2017, Magenta Aps"
__credits__ = ["Carsten Agger", "Dennis Borup Jakobsens"]
__license__ = "GPL"
__version__ = "0.0.1"
__maintainer__ = "Danni Als"
__email__ = "danni@magenta.dk"
__status__ = "Production"


def write_data(data):
    """
    Method for writing data to securityevent.csv
    Provided csv data format should be: TimeStamp, securityEventCode, Tec sum, Raw data
    """

    if(len(data) == 0):
        return

    line = datetime.now().strftime('%Y%m%d%H%M') + ','
    line += ','.join(data)

    csvfile = open("/etc/os2borgerpc/security/securityevent.csv", "a")
    csvfile.write(line + '\n')

    csvfile.close()
