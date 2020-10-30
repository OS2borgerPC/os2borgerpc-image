#!/usr/bin/env python

"""
Security Script for finding sudo events happened within the last 300 seconds.
"""

import sys
from datetime import datetime, timedelta
import csv_writer
import log_read

__author__ = "Danni Als"
__copyright__ = "Copyright 2017-2020 Magenta ApS"
__credits__ = ["Carsten Agger", "Dennis Borup Jakobsens", "Alexander Faithfull"]
__license__ = "GPL"
__version__ = "0.0.6"
__maintainer__ = "Danni Als"
__email__ = "danni@magenta.dk"
__status__ = "Production"


# Get lines from syslog
fname = "/var/log/auth.log"

now = datetime.now()
last_security_check = now - timedelta(seconds=86400)
try:
    with open("/etc/bibos/security/lastcheck.txt", "r") as fp:
        timestamp = fp.read()
        if timestamp:
            last_security_check = datetime.strptime(timestamp, "%Y%m%d%H%M")
except IOError:
    pass

delta_sec = int((now - last_security_check).total_seconds())

lines = ''
if delta_sec <= 86400:
    lines = log_read.read(delta_sec, fname)
else:
    raise ValueError("No security check in the last 24 hours.")

# Ignore if not a sudo event
if lines.partition('sudo:')[2] == "":
    sys.exit()

# securityEventCode, Tec sum, Raw data
csv_data = []
# securityEventCode (security problem id)
csv_data.append("%SECURITY_PROBLEM_UID%")

# find keyword
# select text from auth.log until end of line
before_keyword, keyword, after_keyword = lines.partition('sudo:')
if after_keyword != "":
    splittet_lines = after_keyword.splitlines()
    if(len(splittet_lines) > 0):
        # Tec sum
        csv_data.append("'" + splittet_lines[0] + "'")
    else:
        sys.exit()
else:
    sys.exit()

log_data = before_keyword[-1000:] + keyword + after_keyword[:1000]

log_data = log_data.replace('\n', ' ').replace('\r', '').replace(',', '')

# Raw data
csv_data.append("'" + log_data + "'")

csv_writer.write_data(csv_data)
