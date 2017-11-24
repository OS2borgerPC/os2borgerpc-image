#!/usr/bin/env bash

AS_USER=user

HOME=/home/$AS_USER

HIDDEN_DIR=/home/.skjult 

mkdir -p "$HOME"/.cache/unity
touch "$HOME"/.cache/unity/first_run.stamp

mkdir -p "$HIDDEN_DIR"/.cache/unity

cp "$HOME"/.cache/unity/first_run.stamp "$HIDDEN_DIR"/.cache/unity/first_run.stamp


