#!/bin/bash


# // UPTIME // run 'uptime'
echo -ne "${CYAN}uptime${NC} ~ "
# if /proc/uptime found convert time
raw_sec=$(head /proc/uptime | awk '{print $1}')
raw_sec=${raw_sec%\.*}
if [[ -e /proc/uptime ]] ; then
	#da math
	printf '%d weeks, %d hours, %d minutes \n' $(($raw_sec/604800)) $(($raw_sec/3600)) $(($raw_sec%3600/60))
else
	echo timeless
fi
