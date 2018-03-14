#!/usr/bin/env bash

lpadmin -d $1
lpstat -d
