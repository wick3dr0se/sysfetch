#!/bin/bash

echo -ne "${CYAN}uptime${NC} ~ "
if [[ -e /proc/uptime ]] ; then
	printf '%d days, %d hours, %d minutes \n' $(($sec/86400)) $(($sec%86400/3600)) $(($sec%3600/60))
elif [[ $(command -v uptime) ]] ; then
	uptime | awk '{print($3),($4)}' | sed 's/.$//'
fi
