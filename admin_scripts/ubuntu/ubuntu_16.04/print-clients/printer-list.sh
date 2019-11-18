#!/usr/bin/env bash

printf "\n\nTilgængelige printere:\n\n"
lpinfo -v

printf "\n\nTilføjede printere:\n\n"
lpc status && printf "\n" && lpstat -s

exit 0
