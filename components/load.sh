#!/bin/bash
echo -ne "${PURPLE}load${NC} ~ "
if [[ "$sys" = "Darwin" ]] ; then
	top -l1 -F -n0 -s3 | grep "CPU usage" | awk -F: '{print($2)}'
elif [[ -e /proc/loadavg ]]
	head /proc/loadavg
fi
