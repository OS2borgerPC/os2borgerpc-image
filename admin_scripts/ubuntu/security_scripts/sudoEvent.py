#!/usr/bin/env python

"""
Security Script for finding sudo events happened within the last 300 seconds.
"""

import sys
import csv_writer
import log_read

__author__ = "Danni Als"
__copyright__ = "Copyright 2017, Magenta Aps"
__credits__ = ["Carsten Agger", "Dennis Borup Jakobsens"]
__license__ = "GPL"
__version__ = "0.0.1"
__maintainer__ = "Danni Als"
__email__ = "danni@magenta.dk"
__status__ = "Production"


# Get lines from syslog
fname = "/var/log/auth.log"
lines = log_read.read(300, fname)

# Ignore if not a sudo event
if lines.partition('sudo:')[2] == "":
    sys.exit()

# securityEventCode, Tec sum, Raw data
csv_data = []
# securityEventCode (security problem id)
csv_data.append("SUDOEVENT")

# find keyword
# select text from auth.log until end of line
before_keyword, keyword, after_keyword = lines.partition('sudo:')
if after_keyword != "":
    splittet_lines = after_keyword.splitlines()
    if(len(splittet_lines) > 0):
        # Tec sum
        csv_data.append("'" + splittet_lines[0] + "'")

lines = lines.replace('\n', ' ').replace('\r', '').replace(',', '')

# Raw data
csv_data.append("'" + lines + "'")

csv_writer.write_data(csv_data)
