#!/bin/bash

grep "ChrootDirectory /bibos-archive" /etc/sshd_config > /dev/null
if [ $? -ne 0 ]; then
    TMPFILE=`mktemp /tmp/XXXXXXXXXXX.tmp`
    MATCH='Subsystem sftp \/usr\/lib\/openssh\/sftp-server'
    sed "s/${MATCH}/#${MATCH}/" /etc/ssh/sshd_config > $TMPFILE
    (
	cat <<EOT

### BibOS changes start ###
Subsystem sftp internal-sftp
Match User bibos-archive
    ChrootDirectory /bibos-archive
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTCPForwarding no

### BibOS changes end ###

EOT
    ) >> $TMPFILE
    cat $TMPFILE
    rm $TMPFILE
fi