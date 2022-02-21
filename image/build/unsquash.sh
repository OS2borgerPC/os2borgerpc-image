#!/bin/bash

ISO_DIR="$1"

sudo unsquashfs -f "$ISO_DIR"/casper/filesystem.squashfs
