#!/usr/bin/env bash

# Check required parameters
if [ $# -ne 1 ]
then
    echo "Dette script kræver 1 input-parameter"
    exit 1
fi

lpadmin -d $1 && lpstat -d
