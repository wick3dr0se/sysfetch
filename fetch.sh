#!/bin/bash

#colorsi
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
user=$(whoami)
echo -ne "\e[3m${PURPLE}$user${NC}\e[0m"
echo -e "\e[3m@${YELLOW}$host${NC}\e[0m"


# // KERNEL // w/ uname
echo -ne "${BLUE}kernel${NC} ~ "
uname -r


# // UPTIME // run 'uptime'
echo -ne "${CYAN}uptime${NC} ~ "
uptime --pretty | sed -e 's/up//;s/^ *//'


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
else
	echo -ne "${YELLOW}de/wm${NC} ~ "
	xprop -root | grep '^_NET_WM_NAME' | sed 's/^_NET_WM_NAME//g;s/(UTF8_STRING) = //g' | tr -d '\n'
fi


# // THEME // if file exist print 'gtk-theme-name'
echo -ne " \e \e \e \e "
echo -ne "${BLUE}theme${NC} ~ "
if test -e ~/.config/gtk-3.0/ ; then
	grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'
elif command -v gsettings ; then
	echo $(gsettings get org.gnome.desktop.interface gtk-theme | tr -d '\n')
else
	echo not found
fi


# // CPU // return cpu model name from /proc/cpuinfo
echo -ne "${RED}cpu${NC} ~ "
awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/\<Processor\>//g;s/^ *//' | tr -d '\n'

# get cpu frequency if /sys/devices/system/cpu exist
if test -e /sys/devices/system/cpu/cpu0/cpufreq ; then
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | sed 's/......$/.&/;s/.....$//' | tr -d '\n'
	echo -ne @ ; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | sed 's/......$/.&/;s/....$//' | tr -d '\n' ; echo GHz
fi





#if test -e /sys/devices/system/cpu/cpu0/cpufreq ; then
#	 | head -n1 | sed 's/......$/.&/;s/...$//;s/^/@/'| tr -d '\n' ; echo " GHz"
#fi


# // GPU // w/ lspci
if lspci | grep -qi --color 'vga\|3d\|2d'; then
	echo -ne "${PURPLE}gpu${NC} ~ "
	lspci | grep -i --color 'vga\|3d\|2d' | sed 's/VGA compatible controller//;s/Advanced Micro Devices, Inc//;s/NVIDIA Corporation//' | tr -d '.:[]' | sed 's/^.....//;s/^ *//'
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
else
	echo not found
fi


# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${CYAN}ram${NC} ~ "
awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo | tr -d '\n'


# // SWAP // print 'Size' from /proc/swaps
swap_kb=$(cat /proc/swaps | grep -vi filename | awk '{n+=$3} END {print n}')
if [ -n "$swap_kb" ] ; then
	let "swap_mb = $swap_kb /	 1024"
	echo -ne " \e \e \e \e "
	echo -ne "${YELLOW}swap${NC} ~ "
	echo $swap_mb MiB
else
	echo ''
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
