#!/bin/bash

#colors
NC='\033[0m'
BLACK='\033[1;30m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'

# // HOST@USER // w/ uname & whoami
host=$(uname -n)
user=$(echo $USER)
echo -ne "\e[3m${PURPLE}$user${NC}\e[0m"
echo -e "\e[3m@${YELLOW}$host${NC}\e[0m"


# // KERNEL // w/ uname
echo -ne "${BLUE}kernel${NC} ~ "
uname -r


# // UPTIME // run 'uptime'
echo -ne "${CYAN}uptime${NC} ~ "
# check for uptime --pretty instead of file; run if found
if [[ $(command -v uptime --pretty )  ]] ; then
	uptime --pretty | sed -e 's/up//;s/^ *//'
else
	UPTIME=$(uptime)
	UPTIME=$(echo -n "$UPTIME" | sed -e 's/^.*up //')
	UPTIME=$(echo "$UPTIME" | sed -e 's/load.*$//')
	UPTIME=${UPTIME%\,*}
	echo "$UPTIME"
fi


# // OS // ARCH // print 'PRETTY_NAME' / get processor speed
echo -ne "${GREEN}os${NC} ~ "
awk -F '"' '/PRETTY/ {print $2}' /etc/os-release | tr -d '\n'
# get architecture with uname
echo -ne " \e \e \e \e "
echo -ne "${PURPLE}arch${NC} ~ "
uname -m


# // DE/WM // if file exist print 'DesktopNames'
echo -ne "${YELLOW}de/wm${NC} ~ "
if test -e /usr/share/xsessions/  ; then
	 cat /usr/share/xsessions/* | grep -i 'names=' | sed 's/DesktopNames=//' | tr -d '\n'
elif test -e /usr/share/wayland-sessions/* ; then
	cat /usr/share/wayland-sessions/* | grep -i 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
elif [[ $(command -v xprop) ]] ; then
	xprop -root | grep '^_NET_WM_NAME' | sed 's/^_NET_WM_NAME//g;s/(UTF8_STRING) = //g' | tr -d '\n'
else
	echo not found
fi


# // THEME // if file exist print 'gtk-theme-name'
echo -ne " \e \e \e \e "
echo -ne "${BLUE}theme${NC} ~ "
if test -e ~/.config/gtk-3.0/settings.ini ; then
	grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'
elif [[ $(command -v gsettings) ]] ; then
	echo $(gsettings get org.gnome.desktop.interface gtk-theme | tr -d '\n')
else
	echo not found
fi


# // CPU // try cpu model from lscpu if not found /proc/cpuinfo
vendor=$(cat /proc/cpuinfo | grep -m1 "vendor_id" | sed 's/vendor_id//' | tr -d '\t :')
echo -ne "${RED}cpu${NC} ~ "
if [[ $(command -v lscpu) ]] ; then
	lscpu | grep 'Model name' | sed 's/Model name://;s/Processor//;s/(TM)//;s/(R)//;s/@//;s/CPU//;s/^ *//' | tr -d '\n'
elif [ $vendor =~ GenuineIntel ] ; then
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/(TM)//;s/(R)//;s/@//;s/CPU//;s/^ *//;s/....$//' | tr -d '\n'
else
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/CPU//;s/^ *//' | tr -d '\n'
fi


# get cpu frequency if /sys/devices/system/cpu exist
max_cpu=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | sed 's/......$/.&/;s/....$//' | tr -d '\n' ; echo GHz)
scal_cpu=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | sed 's/......$/.&/;s/.....$//' | tr -d '\n')
if test -e /sys/devices/system/cpu/cpu0/cpufreq ; then
	echo -ne "${CYAN}$scal_cpu${NC}"
	echo -e "@${YELLOW}$max_cpu${NC}"
else
	echo -e '\n'
fi


# // GPU // with lscpi
if [[ $(command -v lspci) ]] ; then
	echo -ne "${PURPLE}gpu${NC} ~ "
	lspci | grep -i --color 'vga\|3d\|2d' | sed 's/VGA compatible controller//;s/Advanced Micro Devices, Inc//;s/NVIDIA Corporation//;s/Corporation//;s/Controller//;s/Family//;s/Processor//;s/Mixture//;s/Model//;s/Generation/Gen/g' | tr -d '.:[]' | sed 's/^.....//;s/^ *//'
else 
	echo -e '\n'
fi

# // PKGS // if package manager found run query
echo -ne "${BLUE}pkgs${NC} ~ "
if [[ $(command -v pacman) ]] ; then
	pacman -Q | wc -l
elif [[ $(command -v dpkg-query) ]]; then
	dpkg-query -l | grep -c '^ii'
elif [[ $(command -v dnf) ]] ; then
	dnf list installed | grep ".@." -c
elif [[ $(command -v rpm) ]] ; then
	rpm -qa | wc -l
elif test -e /var/log/packages ; then
	ls /var/log/packages | wc -l
elif [[ $(command -v opkg) ]] ; then
	opkg list-installed | wc -w
else
	echo not found
fi


# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${CYAN}ram${NC} ~ "
awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo | tr -d '\n'


# // SWAP // print 'Size' from /proc/swaps
swap_kb=$(cat /proc/swaps | grep -vi filename | awk '{n+=$3} END {print n}')
if [ -n "$swap_kb" ] ; then
	let "swap_mb = $swap_kb / 1024"
	echo -ne " \e \e \e \e "
	echo -ne "${YELLOW}swap${NC} ~ "
	echo $swap_mb MiB
else
	echo "\n"
fi


# // TERM // get terminal name w/ pstree
shell="$(echo $SHELL | sed 's%.*/%%')"
term="$(pstree -sA $$)"; term="$(echo ${term%---${shell}*})"; term="$(echo ${term##*---})"

echo -ne "${GREEN}term${NC} ~ "
echo $term | tr -d "\n"


# // SHELL // echo '$SHELL' enviornment variable
echo -ne " \e \e \e \e "
echo -ne "${RED}shell${NC} ~ "
echo $shell
