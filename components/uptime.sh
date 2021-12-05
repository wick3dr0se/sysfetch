#!/bin/bash

echo -ne "${BLUE}uptime${NC} ~ "
if [[ -e /proc/uptime ]] && [[ "$days" = "0" ]] && [[ "$hrs" = "0" ]] ; then
	printf '%d mins \n' $mins
elif [[ -e /proc/uptime ]] && [[ "$days" = "0" ]] ; then
	printf '%d hrs, %d mins \n' $hrs $mins
elif [[ $(command -v uptime) ]] ; then
	uptime | awk '{print($3),($4)}' | sed 's/.$//'
fi

