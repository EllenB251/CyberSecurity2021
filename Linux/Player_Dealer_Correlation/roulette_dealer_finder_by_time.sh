#!/bin/bash

# $1 is the filename containing the date in 4 digits (e.g. 0310)
# $2 is the hour (e.g. 5)
# $3 is AM or PM

awk '{print $1, $2, $5, $6}' ./$1* | grep $2 | grep -iw $3
