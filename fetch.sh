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

# // HOST // ARCH // KERNEL // run uname
echo -ne "${RED}host${NC} ~ " ; uname -n
echo -ne "${YELLOW}arch${NC} ~ " ; uname -m
echo -ne "${GREEN}kernel${NC} ~ " ; uname -r

# // UPTIME // run 'uptime' 
echo -ne "${CYAN}uptime${NC} ~ "
uptime --pretty | sed -e 's/up//'

# // SHELL // echo '$SHELL' enviornment variable
echo -ne "${BLUE}shell${NC} ~ "
echo $SHELL | sed 's%.*/%%'

# // OS // print 'PRETTY_NAME'
echo -ne "${PURPLE}os${NC} ~ "
awk -F '"' '/PRETTY/ {print $2}' /etc/os-release

# // DE/WM // if file exist print 'DesktopNames'
if test -e /usr/share/xsessions/  ; then
	echo -ne "${RED}de/wm${NC} ~ "
	awk '/^DesktopNames/' /usr/share/xsessions/* | sed 's/DesktopNames=//g' | sed 's/\;/\n/g' | sed '/^$/d' | sort -u | sed ':a;N;$!ba;s/\n/, /g'
fi

# // GTK // if file exist print 'gtk-theme-name'
if test -e ~/.config/gtk-3.0/ ; then
	echo -ne "${YELLOW}gtk${NC} ~ "
	grep 'gtk-theme-name' ~/.config/gtk-3.0/* | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'	
fi

# // CPU // return cpu model name from /proc/cpuinfo
echo -ne "${GREEN}cpu${NC} ~ "
awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo

# // PKGS // if package manager found run query
echo -ne "${CYAN}pks${NC} ~ "
if [[ $(command -v pacman) ]]; then
	pacman -Q | wc -l
elif [[ $(command -v dpkg-query) ]]; then
	dkpg-query -l | grep -c '^.i'
else
	echo not found
fi

# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${BLUE}ram${NC} ~ "
awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo 

# // TERM // echo $TERM variable
echo -ne "${PURPLE}term${NC} ~ "
echo $TERM
