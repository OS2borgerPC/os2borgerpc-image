#!/usr/bin/env bash

# Delete printer
lpadmin -x $1

# Test if printer is deleted
if [ -z `lpc status | grep $1` ]
then
    echo "$1 er blevet slettet"
else
    echo "Der er sket en fejl og $1 blev ikke slettet"
fi
