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

# output errors to null
# exec 2>/dev/null

# hostname, architecture & kernel from uname
echo -ne "${RED}host${NC} ~ "
uname -n
echo -ne "${YELLOW}arch${NC} ~ "
uname -m
echo -ne "${GREEN}kernel${NC} ~ "
uname -r

# uptime using uptime
echo -ne "${CYAN}uptime${NC} ~ "
uptime --pretty | sed -e 's/up//'

# check shell enviornment variable
echo -ne "${BLUE}shell${NC} ~ "
echo $SHELL | sed 's%.*/%%'

# PRETTY_NAME from /etc/os-release
echo -ne "${PURPLE}os${NC} ~ "
os=$(awk -F '"' '/PRETTY/ {print $2}' /etc/os-release)
echo "$os"

# desktop enviornment from xsessions
# i'm not going to explain how this sed-mess works, think of it as an exercise for the reader :)
dnames=$(awk '/^DesktopNames/' /usr/share/xsessions/* | sed 's/DesktopNames=//g' | sed 's/\;/\n/g' | sed '/^$/d' | sort -u | sed ':a;N;$!ba;s/\n/, /g')
if test ! -z "$dnames"; then
    echo -e "${RED}de/wm${NC} ~ ${dnames}"
fi

# gtk theme, if exist print name
gtk=`grep 'gtk-theme-name' ~/.config/gtk-3.0/* | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'`
if test ! -z "${gtk}"; then
    echo -e "${YELLOW}gtk${NC} ~ ${gtk}"
fi
# print model name from /proc/cpuinfo
echo -ne "${GREEN}cpu${NC} ~ "
awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo

# installed packages from package manager
echo -ne "${CYAN}pks${NC} ~ "
if [ -x "$(command -v pacman)" ]; then
	pacman -Q | wc -l
elif [ -x "$(command -v dpkg-query)" ]; then
	dpkg-query -l | grep -c '^.i'
else
	echo -n "0 (unrecognised package manager)";
fi

# MemTotal in /proc/meminfo
echo -ne "${BLUE}ram${NC} ~ "
awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo 

# print $TERM variable
echo -ne "${PURPLE}term${NC} ~ "
echo $TERM
