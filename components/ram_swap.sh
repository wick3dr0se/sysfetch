#!/bin/bash

# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${RED}ram${NC} ~ "
if [[ "$sys" = "Darwin" ]] ; then
	echo -n "$(top -l 1 -s 0 | grep PhysMem | awk '{print($2)}' | sed 's/.$//')"
	echo -n "@"
	hostinfo | awk 'FNR == 8 {print($4)}' | sed 's/...$//'
elif [[ ! -z "$max_ram" ]] ; then
	echo -n "$cur_ram$max_ram"
else
	echo -n "no ram"
fi


# // SWAP // print 'Size' from /proc/swaps
if [[ "$sys" = "Darwin" ]] ; then
	echo -ne "${PURPLE}swap${NC} ~ "
	sysctl vm.swapusage | awk -F: '{print($2)}' | sed 's/.(encrypted)$//'
elif [[ "$swap_count" = "2" ]] ; then
	let "swap1_mb = $swap1_kb / 1024"
	echo -ne " \e \e \e \e ${PURPLE}swap${NC} ~ "
	echo "$swap1_mb MiB"
elif [[ "$swap_count" > "2" ]] ; then
	let "swap1_mb = $swap1_kb / 1024"
	echo -ne " \e \e \e \e ${PURPLE}swap${NC} ~ "
	echo -ne "$swap1_mb MiB " | sed 's/ //'
	let "swap2_mb = $swap2_kb / 1024"
	echo "$swap2_mb MiB" | sed 's/ //'
else
	echo -ne "\n"
fi
    
