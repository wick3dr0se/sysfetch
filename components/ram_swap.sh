#!/bin/bash


# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${GREEN}ram${NC} ~ "
awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo | tr -d '\n' 


# // SWAP // print 'Size' from /proc/swaps
swap_count=$(head /proc/swaps | wc -l)
swap1_kb=$(sed -n '2p' /proc/swaps | awk '{print($3)}')
swap2_kb=$(sed -n '3p' /proc/swaps | awk '{print($3)}')
if [[ $swap_count = 2 ]] ; then  
        let "swap1_mb = $swap1_kb / 1024"
        echo -e " \e \e \e \e " | tr -d '\n'
        echo -ne "${PURPLE}swap${NC} ~ "
        echo -e "$swap1_mb MiB"     
elif [[ $swap_count -ge 3 ]] ; then 
        let "swap1_mb = $swap1_kb / 1024"
        echo -e " \e \e \e \e " | tr -d '\n'
        echo -ne "${PURPLE}swap${NC} ~ "
        echo -ne "$swap1_mb MiB " | sed 's/ //'
        let "swap2_mb = $swap2_kb / 1024"
        echo -e "$swap2_mb MiB" | sed 's/ //'
fi
