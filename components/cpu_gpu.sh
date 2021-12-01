#!/bin/bash

# // CPU //
echo -ne "${CYAN}cpu${NC} ~ "
if [[ "$sys" = "Darwin" ]] ; then
	echo -ne "$(sysctl -n machdep.cpu.brand_string)"
elif [[ "$cpu_vendor" = "GenuineIntel" ]] ; then
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/(TM)//;s/(R)//;s/@//;s/CPU//;s/^ *//;s/.......$//' | tr -d '\n'
else
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/CPU//;s/^ *//' | tr -d '\n'
fi

# get cpu frequency from /sys/devices/system/cpu
if [[ ! -z $max_cpufreq ]] ; then
	echo -ne "$max_cpufreq"
	echo -ne "@${CYAN}$cur_cpufreq${NC}" ; echo "GHz"
else
	echo -ne "\n"
fi


# // GPU // with lscpi
if [[ "$sys" = "Darwin" ]] ; then
	echo -ne "${GREEN}gpu${NC} ~ "
	system_profiler SPDisplaysDataType | grep Chipset | awk -F: '{print($2)}'
elif [[ "$kernel" = *"microsoft-standard-WSL"* ]] ; then
	echo -ne "${GREEN}gpu${NC} ~ "
	wmic.exe path win32_VideoController get name | awk 'NR==2'
elif [[ $(command -v lspci) ]] ; then
	echo -ne "${GREEN}gpu${NC} ~ "
	lspci | grep -im1 --color 'vga\|3d\|2d' | sed 's/VGA compatible controller//;s/Advanced Micro Devices, Inc//;s/NVIDIA Corporation//;s/Corporation//;s/Controller//;s/controller//;s/storage//;s/filesystem//;s/0000//;s/Family//;s/Processor//;s/Mixture//;s/Model//;s/Generation/Gen/g' | tr -d '.:[]' | sed 's/^.....//;s/^ *//'
fi

