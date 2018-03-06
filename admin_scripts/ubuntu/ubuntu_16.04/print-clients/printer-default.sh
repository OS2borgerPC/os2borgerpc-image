#!/bin/bash

lpadmin -d $1
lpstat -d
