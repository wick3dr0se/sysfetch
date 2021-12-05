#/bin/bash

# // MOBO // 
if [[ "$os" = "Darwin" ]] ; then
	echo -e "${GREEN}mobo${NC} ~ $(system_profiler SPHardwareDataType | awk 'FNR == 6 {print($3)}')"
elif [[ -e /sys/devices/virtual/dmi/id/board_name ]] ; then
	echo -ne "${GREEN}mobo${NC} ~ "
	echo -e "$mobo_vendor $mobo_name"
fi

