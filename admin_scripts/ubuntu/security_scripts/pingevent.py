#!/usr/bin/env python3

import sys
import csv_writer

# securityEventCode, Tec sum, Raw data
csv_data = []
# securityEventCode (security problem id)
csv_data.append("%SECURITY_PROBLEM_UID%")

# Tec sum
csv_data.append("Ping warning.")

# Raw data
csv_data.append("Nothing to worry about. Just a ping warning.")

csv_writer.write_data(csv_data)

