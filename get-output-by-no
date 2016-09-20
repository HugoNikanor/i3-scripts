#!/bin/bash

# Return the name of the output at the n:th location (starting from 1)
# from the left.

# Currently only works with horizontally stacked monitors, this should
# be improved to handle any monitor configuration

xrandr --current \
	| awk \
		'/[^d][^i][^s]connected/ {
			split($3, data, "+");
			split(data[1], resolution, "x");
			print data[2] / resolution[1] "	" $1;
		}' \
	| sort \
	| cut -f 2 \
	| sed -n "$1p"
