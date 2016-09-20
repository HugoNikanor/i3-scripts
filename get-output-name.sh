#!/bin/bash

# returns the monitor at the physical location $1
# hopefully, I have only tested it on one system as of yet

# known positions
#	normal
#	left

# *monitor-name* connected *res* *hex?* *[pos]* *(rotation)* *size* x *size*
xrandr -q --verbose | grep -P '(?<!dis)connected' | while read monitor; do
	awk -v position=$1 '$5 == position {print $1}' <<< $monitor
done
