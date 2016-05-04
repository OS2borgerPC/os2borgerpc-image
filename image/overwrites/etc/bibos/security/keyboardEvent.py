#!/usr/bin/env python

import sys
import csv_writer
import syslog_read

# Get lines from syslog
lines = syslog_read.read(30)

# Ignore if not a keyboard event
if(lines.partition('keyboard')[2] == ""):
        sys.exit()

# securityEventCode, Tec sum, Raw data
csv_data = []
# securityEventCode (security problem id)
csv_data.append("KEYBOARD")

# Ignore first argument
for i in range(1, len(sys.argv)):
        # find keyword
        # select text from keyword until end of line
        before_keyword, keyword, after_keyword = lines.partition(sys.argv[i])
        if(after_keyword != ""):
            splittet_lines = after_keyword.splitlines()
            if(len(splittet_lines) > 0):
                # Tec sum
                csv_data.append("'" + splittet_lines[0] + "'")

lines = lines.replace('\n', ' ').replace('\r', '').replace(',', '')

# Raw data
csv_data.append("'" + lines + "'")

csv_writer.write_data(csv_data)
