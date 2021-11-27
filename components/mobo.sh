#!/bin/bash

if [[ -e /sys/devices/virtual/dmi/id/board_name ]] ; then
	echo -ne "${BLUE}mobo${NC} ~ "
	echo -e "$mobo_vendor $mobo_name"
fi
