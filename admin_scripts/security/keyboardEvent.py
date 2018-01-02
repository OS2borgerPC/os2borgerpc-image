#!/usr/bin/env python

import sys
import csv_writer
import log_read

# The estimated boot time, in seconds.
# This is what you need to change if you wish to adjust the window in which we
# ignore keyboard events.
BOOT_TIME=120


with open('/proc/uptime', 'r') as f:
    uptime_seconds = int(f.readline().split('.')[0])

if uptime_seconds <= BOOT_TIME:
    sys.exit()

# Get lines from syslog
fname = "/var/log/syslog"
lines = log_read.read(300, fname)


# Ignore if not a keyboard event
if (lines.partition('keyboard')[2] == "" and
    lines.partition('Keyboard')[2] == ""):
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

lines = lines.replace('\n', ' ').replace('\r', '').replace(',', '')

# Raw data
csv_data.append("'" + lines + "'")

csv_writer.write_data(csv_data)
