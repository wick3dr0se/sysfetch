#!/bin/bash


# // UPTIME // run 'uptime'
echo -ne "${CYAN}uptime${NC} ~ "
# if /proc/uptime found convert time
sec=$(awk '{print $1}' /proc/uptime)
sec=${sec%\.*}
if [[ -e /proc/uptime ]] ; then
	#da math
	printf '%d days, %d hours, %d minutes \n' $(($sec%604800/86400)) $(($sec%86400/3600)) $(($sec%3600/60))
fi
