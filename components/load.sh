#!/bin/bash

case $systype in

  Linux)

    # // LOAD AVGS //
    echo -ne "${PURPLE}load${NC} ~ "
    [[ -e /proc/loadavg ]] ; head /proc/loadavg
    ;;

  Darwin)

    # // LOAD AVGS // using a single sample of top.
    echo -ne "${PURPLE}load${NC} ~ "
    top -l1 -F -n0 -s3 | grep "CPU usage" | awk -F: '{print($2)}'
    ;;
    
esac
