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

# // HOST // KERNEL // run uname
echo -ne "${RED}host${NC} ~ " ; uname -n
echo -ne "${YELLOW}kernel${NC} ~ " ; uname -r

# // UPTIME // run 'uptime' 
echo -ne "${GREEN}uptime${NC} ~ "
uptime --pretty | sed -e 's/up//'

# // OS // print 'PRETTY_NAME'
echo -ne "${CYAN}os${NC} ~ "
awk -F '"' '/PRETTY/ {print $2}' /etc/os-release | tr -d '\n' 
echo -ne "${GREEN} \e \e \e \e arch${NC} ~ "
uname -m

# // DE/WM // if file exist print 'DesktopNames'
if test -e /usr/share/xsessions/  ; then
	echo -ne "${BLUE}de/wm${NC} ~ "
	awk '/^DesktopNames/' /usr/share/xsessions/* | sed 's/DesktopNames=//g' | sed 's/\;/\n/g' | sed '/^$/d' | sort -u | sed ':a;N;$!ba;s/\n/, /g' | tr -d "\n"
fi

# // GTK // if file exist print 'gtk-theme-name'
if test -e ~/.config/gtk-3.0/ ; then
	echo -ne "${CYAN} \e \e \e \e gtk${NC} ~ "
	grep 'gtk-theme-name' ~/.config/gtk-3.0/* | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'	
fi

# // CPU // return cpu model name from /proc/cpuinfo
echo -ne "${PURPLE}cpu${NC} ~ "
awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/\<Processor\>//g' | tr -d '\n'
# get cpu frequency if /sys/devices/system/cpu exist
if test -e /sys/devices/system/cpu ; then
	sort -rn /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq | head -n1 | sed 's/......$/.&/;s/...$//'| tr -d '\n' ; echo " GHz"
fi

# // PKGS // if package manager found run query
echo -ne "${RED}pkgs${NC} ~ "
if [[ $(command -v pacman) ]]; then
	pacman -Q | wc -l
elif [[ $(command -v dpkg-query) ]]; then
	dpkg-query -l | grep -c '^.i'
else
	echo not found
fi

# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${YELLOW}ram${NC} ~ "
awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo | tr -d '\n'

# // SWAP // print 'Size' from /proc/swaps
swapK=$(awk '{print $3}' /proc/swaps | sed '1d')
let "swapM = $swapK / 1024"
if test -e /proc/swaps ; then
	echo -ne "${BLUE} \e \e \e \e swap${NC} ~ "
	echo $swapM MiB
fi

# // TERM // echo $TERM variable
echo -ne "${GREEN}term${NC} ~ "
echo $TERM | tr -d "\n"

# // SHELL // echo '$SHELL' enviornment variable
echo -ne "${PURPLE} \e \e \e \e shell${NC} ~ "
echo $SHELL | sed 's%.*/%%'
