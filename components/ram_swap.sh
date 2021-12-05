#!/bin/bash

# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${RED}ram${NC} ~ "
if [[ "$os" = "Darwin" ]] ; then
	echo -n "$(top -l 1 -s 0 | grep PhysMem | awk '{print($2)}' | sed 's/.$//')"
	echo -n "M/"
	hostinfo | awk 'FNR == 8 {print($4)}' | sed 's/...$//' | tr -d '\n'
	echo -n "G"
elif [[ ! -z "$max_ram" ]] ; then
	echo -ne "$cur_ram$max_ram MiB \e \e \e \e "
else
	echo -ne "no ram \e \e \e \e "
fi


# // SWAP // print 'Size' from /proc/swaps
if [[ "$os" = "Darwin" ]] ; then
	echo -ne "${PURPLE}swap${NC} ~ "
	sysctl vm.swapusage | awk '{print($7)}'
elif [[ -e /proc/swaps ]] ; then
	echo -ne "${PURPLE}swap${NC} ~ "
	echo "$swap_cur/$swap_max MiB"
else
	echo -ne "\n"
fi
