#!/bin/bash

dpkg-query -W --showformat='${Package} ${Version}\n'
