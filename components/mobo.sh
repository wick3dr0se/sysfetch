#/bin/bash

# // MOBO // 
if [[ "$sys" = "Darwin" ]] ; then
	echo -e "${YELLOW}mobo${NC} ~ "
	system_profiler SPHardwareDataType | awk 'FNR == 6 {print($3)}'
elif [[ -e /sys/devices/virtual/dmi/id/board_name ]] ; then
	echo -ne "${YELLOW}mobo${NC} ~ "
	echo -e "$mobo_vendor $mobo_name"
fi

