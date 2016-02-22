#!/bin/bash

# moves to the next numbered workspace on the current screen, 
# requires the next workspace to follow the naming convention:
# screenname:number <name>

# TODO it wraps weirdly, and creates new workspaces a bit weird to

echo "$1"

if ! [ "$1" == "1" ] || [ "$1" == "-1" ]; then
	echo "use step-workspace 1 to move to the next workspace"
	echo "and -1 for previus workspace"
	exit 1
fi


# get current display and workspace
currentOut="$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].output')"
workspaceNum=$(
		i3-msg -t get_workspaces |\
		jq "map(select(.focused))[0].name" |\
		sed -n  "s/^\"$currentOut:\([1-9]\|10\).*/\1/p")

# you dont want to swith to the current workspace
workspaceNum="$(($workspaceNum + $1))"

# Try moving to the next workspace over
goalNum="10"
if [ "$1" == "-1" ]; then
	goalNum="1"
fi
for x in $(seq "$workspaceNum" "$1" "$goalNum"); do
	# check if the workspace exists
	wanted="$(i3-msg -t get_workspaces |\
	   	jq "map(select(.output==\"$currentOut\"))[].name" |\
	   	sed -n "s/^\"$currentOut:\($x\).*/\1/p")"
	# try to go to it
	ret="$(move-to-workspace "$wanted" | jq '.[0].success')"

	# stop trying to change workspace if changed above 
	if [ "$ret" == "true" ]; then
		echo "test"
		break;
	fi
done

# create a new workspace if none was found
if [ "$ret" != "true" ]; then
	move-to-workspace "$workspaceNum"
fi
