#/bin/bash

case $systype in

  Linux)

    # // MOBO // get motherboard vendor & name if exist
    if [[ -e /sys/devices/virtual/dmi/id/board_name ]] ; then
          echo -ne "${YELLOW}mobo${NC} ~ "
          echo -e "$mobo_vendor $mobo_name"
    fi
    ;;

  Darwin)

    # // MOBO // pulling Mac Model from sysprofile
    macmobo=$(system_profiler SPHardwareDataType | awk 'FNR == 6 {print($3)}')
    echo -ne "${YELLOW}mobo${NC} ~ ${macmobo}"
    ;;

esac
