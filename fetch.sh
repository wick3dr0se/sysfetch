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

#store OS information to collect number of packages from different sources(apt or pacman)
os=$(awk -F '"' '/PRETTY/ {print $2}' /etc/os-release)
pkgs=""
case $os in 
*"Ubuntu"*|*"Mint"*|*"Debian"*|*"Pop!_OS")
    pkgs=$(dpkg-query -l | grep "^ii" | wc -l)
    ;;
*"Arch"*)
    pkgs=$(pacman -Q | wc -l)
    ;;
esac

# output errors to null
exec 2>/dev/null

# hostname, architecture & kernel from uname
echo -ne "${RED}host${NC} ~ " ; uname -n
echo -ne "${YELLOW}arch${NC} ~ " ; uname -m
echo -ne "${GREEN}kernel${NC} ~ " ; uname -r

# uptime using uptime
echo -ne "${CYAN}uptime${NC} ~ " ; uptime --pretty | sed -e 's/up//'

# check shell enviornment variable
echo -ne "${BLUE}shell${NC} ~ " ; echo $SHELL | sed 's%.*/%%'

# PRETTY_NAME from /etc/os-release
echo -ne "${PURPLE}os${NC} ~ " ; echo "$os"

# desktop enviornment from xsessions
echo -ne "${RED}de/wm${NC} ~ " ; awk '/^DesktopNames/' /usr/share/xsessions/* | sed 's/DesktopNames=//g'

# gtk theme, if exist print name
echo -ne "${YELLOW}gtk${NC} ~ " ; grep 'gtk-theme-name' ~/.config/gtk-3.0/* | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'

# print model name from /proc/cpuinfo
echo -ne "${GREEN}cpu${NC} ~ " ; grep -m 1 "model name" /proc/cpuinfo | sed 's/^[model name:.* \t]*//'

# installed packages from package manager
echo -ne "${CYAN}pkgs${NC} ~ " ; echo "$pkgs"
# MemTotal in /proc/meminfo
echo -ne "${BLUE}ram${NC} ~ " ; awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo 

# print $TERM variable
echo -ne "${PURPLE}term${NC} ~ " ; echo $TERM
