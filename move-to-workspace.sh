#!/bin/bash

# moves the i3-wm focus to the workspace which have a name starting with the 
# provided number. Note that only 0-9 is supported

hasgrep="$(sed -n 's/^\([0-9]\)$/\1/p' <<< $1)"

if [ -z "$hasgrep" ]; then
	echo "Please give a number between 0 and 9"
	exit 1
fi

names="$(
	i3-msg -t get_workspaces |\
	grep -Po '"name":.*?[^\\]",' |\
	sed 's/"name":"\(.*\)".*/\1/g'
)"

wanted="$(grep "^$1" <<< "$names")"

# create workspace if it doesn't exist 
if [ -z "$wanted" ]; then
	wanted="$1"
fi

i3-msg "workspace $wanted"

