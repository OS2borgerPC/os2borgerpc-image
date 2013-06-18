#!/bin/bash

PROXY_HOST=`get_bibos_config gateway_address 2>/dev/null`
if [ "$PROXY_HOST" != "" ]; then
    http_proxy="http://${PROXY_HOST}:80"
    https_proxy="$http_proxy"
    ftp_proxy="$http_proxy"
    no_proxy="localhost,${PROXY_HOST},`hostname`"
    for ip in `/sbin/ifconfig | grep "inet addr" | sed 's/.*inet addr:\([0-9.]\+\).*/\1/'`; do
	no_proxy="${no_proxy},$ip"
    done
    export http_proxy https_proxy ftp_proxy no_proxy
fi
