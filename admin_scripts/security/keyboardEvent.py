#!/usr/bin/env python

import sys
import csv_writer
import log_read
from datetime import date, datetime, time, timedelta

# Get lines from syslog
fname = "/var/log/syslog"
lines = log_read.read(300, fname)

now = datetime.now()

dt_min = datetime.combine(date.today(), time(7, 40))
dt_max = datetime.combine(date.today(), time(7, 40)) + timedelta(minutes=25)

if now <= dt_max and now >=  dt_min:
	        sys.exit()

# Ignore if not a keyboard event
if lines.partition('keyboard')[2] == ""	and lines.partition('Keyboard')[2] == "":
        sys.exit()

# securityEventCode, Tec sum, Raw data
csv_data = []
# securityEventCode (security problem id)
csv_data.append("KEYBOARD")

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
