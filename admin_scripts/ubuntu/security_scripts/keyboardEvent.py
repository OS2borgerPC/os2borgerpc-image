#!/usr/bin/env python

"""
Security Script for finding USB keyboard attachment events happened within the last 300 seconds.
"""

import sys
import csv_writer
import log_read

__author__ = "Danni Als"
__copyright__ = "Copyright 2017, Magenta Aps"
__credits__ = ["Carsten Agger", "Dennis Borup Jakobsens"]
__license__ = "GPL"
__version__ = "0.0.4"
__maintainer__ = "Danni Als"
__email__ = "danni@magenta.dk"
__status__ = "Production"


# The estimated boot time, in seconds.
# This is what you need to change if you wish to adjust the window in which we
# ignore keyboard events.
BOOT_TIME=500

with open('/proc/uptime', 'r') as f:
    uptime_seconds = int(f.readline().split('.')[0])

if uptime_seconds <= BOOT_TIME:
    sys.exit()

# Get lines from syslog
fname = "/var/log/syslog"
lines = log_read.read(300, fname)


# Ignore if not a keyboard event
if (lines.partition('keyboard')[2] == "" and lines.partition('Keyboard')[2] == ""):
            sys.exit()

# securityEventCode, Tec sum, Raw data
csv_data = []
# securityEventCode (security problem id)
csv_data.append("%SECURITY_PROBLEM_UID%")

# find keyword
# select text from keyword until end of line
before_keyword, keyword, after_keyword = lines.partition('input:')
if after_keyword != "":
    splittet_lines = after_keyword.splitlines()
    if(len(splittet_lines) > 0):
        # Tec sum
        csv_data.append("'" + splittet_lines[0] + "'")
    else:
        sys.exit()
else:
    sys.exit()

lines = lines.replace('\n', ' ').replace('\r', '').replace(',', '')

# Raw data
csv_data.append("'" + lines + "'")

csv_writer.write_data(csv_data)
