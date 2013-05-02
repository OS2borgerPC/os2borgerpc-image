#!/usr/bin/env sh

if [ -z $1 ]
then
    DESTINATION='/'
else
    DESTINATION=$1
fi

cp -r overwrites/* $DESTINATION


