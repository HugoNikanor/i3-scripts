#!/bin/bash

# opens a dmenu for renameing the current i3 workspace 
# keep the number after from before after the rename

currentOut="$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].output')"
workspaceNum=$(i3-msg -t get_workspaces | jq "map(select(.focused))[0].name" | sed -n  "s/^\"$currentOut:\([1-9]\|10\).*/\1/p")

currentname=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name')
namePre="$(grep -Po "^$currentOut:$workspaceNum" <<< $currentname)"
newname="$(echo "" | dmenu -p "rename '$namePre':")"

if [ -n "$newname" ]; then
	newname="$namePre: $newname"
else
	newname="$namePre"
fi

i3-msg rename workspace "\"$currentname\"" to "\"$newname\""
