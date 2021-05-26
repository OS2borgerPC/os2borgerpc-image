#!/bin/bash

set -ex 

PRINTER=$1
PAGE_SIZE=$2
COLOR_MODEL=$3
DUPLEX=$4
# TODO:  to specify Landscape vs Portrait?

if [ $PAGE_SIZE != "-" ]
then
    lpadmin -p $PRINTER -o PageSize=$PAGE_SIZE
fi

if [ $COLOR_MODEL != "-" ]
then
    lpadmin -p $PRINTER -o ColorModel=$COLOR_MODEL
fi

if [ $DUPLEX != "-" ]
then
    lpadmin -p $PRINTER -o Duplex=$DUPLEX
fi


