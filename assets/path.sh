#!/bin/bash

# set src directory
src=$(dirname "$(readlink -f "$0")")
[[ -e /usr/share/sysfetch ]] ; src="/usr/share/sysfetch"

# pull in functions
source "$src/assets/functions.sh"
