#!/bin/bash

# // CPU //
echo -ne "${BLUE}cpu${NC} ~ "
if [[ "$os" = "Darwin" ]] ; then
	echo -ne "$(sysctl -n machdep.cpu.brand_string)"
elif [[ "$cpu_vendor" = "GenuineIntel" ]] ; then
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/(TM)//;s/(R)//;s/@//;s/CPU//;s/^ *//;s/.......$//' | tr -d '\n'
else
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/CPU//;s/^ *//' | tr -d '\n'
fi

# get cpu frequency from /sys/devices/system/cpu
if [[ ! -z $max_cpufreq ]] ; then
	echo -e "${BLUE}$max_cpufreq${NC}${RED}@${NC}${GREEN}$cur_cpufreq${NC} GHz"
else
	echo -ne "\n"
fi


# // GPU // with lscpi
if [[ "$os" = "Darwin" ]] ; then
	echo -ne "${CYAN}gpu${NC} ~ "
	system_profiler SPDisplaysDataType | grep Chipset | awk -F: '{print($2)}'
elif [[ "$kernel" = *"microsoft-standard-WSL"* ]] ; then
	echo -ne "${CYAN}gpu${NC} ~ "
	wmic.exe path win32_VideoController get name | awk 'NR==2'
elif [[ $(command -v lspci) ]] ; then
	echo -ne "${CYAN}gpu${NC} ~ "
	lspci | grep -im1 --color 'vga\|3d\|2d' | sed "$gpu_strip" | tr -d '.:[]' | sed 's/^.....//;s/^ *//'
fi

