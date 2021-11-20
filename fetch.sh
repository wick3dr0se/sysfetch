#!/bin/sh

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
exec 2>/dev/null

# hostname, architecture & kernel from uname
echo -ne "${RED}host${NC} ~ " ; uname -n
echo -ne "${YELLOW}arch${NC} ~ " ; uname -m
echo -ne "${GREEN}kernel${NC} ~ " ; uname -r
# uptime using uptime
echo -ne "${CYAN}uptime${NC} ~ " ; uptime --pretty| sed -e 's/up//'
# check shell enviornment variable
echo -ne "${BLUE}shell${NC} ~ " ; echo $SHELL|sed 's/usr.*bin//g' | tr -d '/'
# PRETTY_NAME from /etc/os-release
echo -ne "${PURPLE}os${NC} ~ " ; awk -F '"' '/PRETTY/ {print $2}' /etc/os-release
# active desktop enviornment with wmctrl \\ !rmv dependacy to external package
echo -ne "${RED}de/wm${NC} ~ " ; wmctrl -m | grep 'Name:' | sed 's/Name: //g'
# gtk theme, if exist print name
echo -ne "${YELLOW}gtk${NC} ~ " ; grep 'gtk-theme-name' ~/.config/gtk-3.0/* | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'
# cpu with lscpu
echo -ne "${GREEN}cpu${NC} ~ " ; lscpu | grep 'Model\ name' | sed 's/^[Model name:.* \t]*//'
# installed packages from package manager
echo -ne "${CYAN}pkgs${NC} ~ " ; pacman -Q | wc -l
# MemTotal in /proc/meminfo
echo -ne "${BLUE}ram${NC} ~ " ; awk '/MemTotal:/ {printf "%d MiB\n", $2 / 1024}' /proc/meminfo 
# TERM info from printenv
echo -ne "${PURPLE}term${NC} ~ " ; printenv | grep -w 'TERM' | sed 's/TERM=//g'
