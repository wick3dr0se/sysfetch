#!/bin/bash

case $systype in

  Linux)

    # // RAM // print 'MemTotal' in /proc/meminfo
    echo -ne "${RED}ram${NC} ~ "
    echo -n "$cur_ram$max_ram"

    # // SWAP // print 'Size' from /proc/swaps
    if [[ "$swap_count" = "2" ]] ; then
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
    ;;

  Darwin)

    # // RAM // using both top and hostinfo.
    macramused=$(top -l 1 -s 0 | grep PhysMem | awk '{print($2)}' | sed 's/.$//')
    macmaxram=$(hostinfo | awk 'FNR == 8 {print($4)}' | sed 's/...$//')
    echo -ne "${RED}ram${NC} ~ "
    echo -n "${macramused}M/${macmaxram}G "

    # // SWAP // using sysctl and awk.
    macswap=$(sysctl vm.swapusage | awk -F:  '{print($2)}' | sed 's/.(encrypted)$//')
    echo -ne "${PURPLE}swap${NC} ~$macswap"
    ;;

esac
