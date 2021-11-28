#!/bin/bash


# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${RED}ram${NC} ~ "
echo -n "$cur_ram$max_ram"

# // SWAP // print 'Size' from /proc/swaps
swap_count=$(head /proc/swaps | wc -l)
swap1_kb=$(sed -n '2p' /proc/swaps | awk '{print($3)}')
swap2_kb=$(sed -n '3p' /proc/swaps | awk '{print($3)}')
if [[ "$swap_count" = "2" ]] ; then  
        let "swap1_mb = $swap1_kb / 1024"
        echo -ne " \e \e \e \e ${YELLOW}swap${NC} ~ "
        echo "$swap1_mb MiB"     
elif [[ "$swap_count" -ge "3" ]] ; then 
        let "swap1_mb = $swap1_kb / 1024"
        echo -ne " \e \e \e \e ${YELLOW}swap${NC} ~ "
        echo -ne "$swap1_mb MiB " | sed 's/ //'
        let "swap2_mb = $swap2_kb / 1024"
        echo "$swap2_mb MiB" | sed 's/ //'
fi
