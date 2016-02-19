#!/bin/bash

wanted="$(i3-msg -t get_workspaces | jq '.[].name' | sed 's/"//g' | dmenu)"
i3-msg "workspace $wanted"
