#!/bin/bash

# // CPU //
echo -ne "${CYAN}cpu${NC} ~ "
case $cpu_vendor in
	AuthenticAMD)
		awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/CPU//;s/^ *//' | tr -d '\n' ;;
	GenuineIntel)
		awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/(TM)//;s/(R)//;s/@//;s/CPU//;s/^ *//;s/.......$//' | tr -d '\n' ;;
esac

# get cpu frequency from /sys/devices/system/cpu
max_cpufreq=$(head /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | sed 's/......$/.&/;s/.....$//')
cur_cpufreq=$(head /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | sed 's/......$/.&/;s/....$//')
if [[ ! -z $max_cpufreq ]] ; then
echo -ne "${CYAN}$max_cpufreq${NC}"
echo -ne "@${YELLOW}$cur_cpufreq${NC}" ; echo "GHz"
fi

# // GPU // with lscpi
if [[ $(command -v lspci) ]] ; then
	echo -ne "${GREEN}gpu${NC} ~ "
	lspci | grep -im1 --color 'vga\|3d\|2d' | sed 's/VGA compatible controller//;s/Advanced Micro Devices, Inc//;s/NVIDIA Corporation//;s/Corporation//;s/Controller//;s/controller//;s/storage//;s/filesystem//;s/0000//;s/Family//;s/Processor//;s/Mixture//;s/Model//;s/Generation/Gen/g' | tr -d '.:[]' | sed 's/^.....//;s/^ *//' 
fi
