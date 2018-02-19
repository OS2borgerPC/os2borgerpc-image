#!/usr/bin/env python

"""
Security Script for finding USB keyboard attachment events happened within the last 300 seconds.
"""

import sys
from datetime import datetime
import csv_writer
import log_read

__author__ = "Danni Als"
__copyright__ = "Copyright 2017, Magenta Aps"
__credits__ = ["Carsten Agger", "Dennis Borup Jakobsens"]
__license__ = "GPL"
__version__ = "0.1.0"
__maintainer__ = "Danni Als"
__email__ = "danni@magenta.dk"
__status__ = "Production"


# Get lines from syslog
fname = "/var/log/syslog"

now = datetime.now().strftime('%Y%m%d%H%M')

try:
    check_file = open("/etc/bibos/security/lastcheck.txt", "r")
except IOError:
    # File does not exists, so we create it.
    os.mknod("/etc/bibos/security/lastcheck.txt")
    check_file = open("/etc/bibos/security/lastcheck.txt", "r")

last_security_check = datetime.strptime(now, '%Y%m%d%H%M')
last_check = check_file.read()
if last_check:
    last_security_check = (
        datetime.strptime(last_check, '%Y%m%d%H%M'))

check_file.close()

delta = datetime.strptime(now, '%Y%m%d%H%M') - last_security_check

delta_ms = int(delta.total_seconds())

lines = ''
# If last security check is 24 hours old, we raise an error.
if delta_ms < 86400:
    lines = log_read.read(delta_ms, fname)
else:
    # No need to delete last_security_check file from here, as the bibos_client should handle this.
    raise ValueError('Last security check has not been performed for the last 24 hours.')

if lines.partition('Power Button')[2] != "":
    sys.exit()

# Ignore if not a keyboard event
if lines.partition('keyboard')[2] == "" and lines.partition('Keyboard')[2] == "":
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
    if len(splittet_lines) > 0:
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
