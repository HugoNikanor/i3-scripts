#!/bin/bash

# moves to the next numbered workspace on the current screen, 
# requires the next workspace to follow the naming convention:
# screenname:number <name>

# TODO it wraps weirdly, and creates new workspaces a bit weird to

# get current display and workspace
currentOut="$(i3-msg -t get_workspaces | jq 'map(select(.focused))[0].output' | sed 's/"//g')"
workspaceNum=$(i3-msg -t get_workspaces | jq "map(select(.focused))[0].name" | sed -n  "s/^\"$currentOut:\([1-9]\|10\).*/\1/p")
# you dont want to swith to the current workspace
workspaceNum="$(($workspaceNum + 1))"

# Try moving to the next workspace over
for x in $(seq "$workspaceNum" 10); do
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
