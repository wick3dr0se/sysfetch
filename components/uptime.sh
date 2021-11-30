#!/bin/bash

case $systype in

  Linux)

    # // UPTIME //
    if [[ -e /proc/uptime ]] ; then
          echo -ne "${CYAN}uptime${NC} ~ "
          printf '%d days, %d hours, %d minutes \n' $(($sec/86400)) $(($sec%86400/3600)) $(($sec%3600/60))
    fi
    ;;

  Darwin)

    #// UPTIME //
    macuptime=$(uptime | awk '{print($3),($4)}' | sed 's/.$//')
    echo -e "${CYAN}uptime${NC} ~ ${macuptime}"
    ;;

esac
