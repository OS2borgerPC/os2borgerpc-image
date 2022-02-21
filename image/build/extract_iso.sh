#!/bin/bash

ISO_FILE=$1
TARGET_DIR=$2

7z x "$ISO_FILE" -o"$TARGET_DIR"

rm -rf "$TARGET_DIR"/\[BOOT\]/



