#!/usr/bin/env python
from datetime import datetime
# Dont give timestamp as argument
# csv format: TimeStamp, securityEventCode, Tec sum, Raw data


def write_data(data):
    if(len(data) == 0):
        return

    line = datetime.now().strftime('%Y%m%d%H%M')

    for d in data:
	line += ',' + d.replace('\n', ' ').replace('\r', '').replace(',', '')

    csvfile = open("/etc/bibos/security/securityevent.csv", "a")
    csvfile.write(line + '\n')

    csvfile.close()
