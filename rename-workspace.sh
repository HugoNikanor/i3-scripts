#!/bin/bash

# opens a dmenu for renameing the current i3 workspace 
# keep the number after from before after the rename

currentname=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name')
echo "$currentname"
number="$(grep -Po '^[0-9]' <<< $currentname)"
echo "$number"
newname="$(echo "" | dmenu -p "(rename) $currentname")"
echo "$newname"
newname="$number: $newname"
echo "$newname"

i3-msg rename workspace "\"$currentname\"" to "\"$newname\""
