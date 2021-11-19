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
# uptime w/ uptime
echo -ne "${CYAN}uptime${NC} ~ " ; uptime --pretty| sed -e 's/up//'
# shell from enviornment variable
echo -ne "${BLUE}shell${NC} ~ " ; echo $SHELL|sed 's/usr.*bin//g' | tr -d '/'
# RETTY_NAME from /etc/os-release
echo -ne "${PURPLE}os${NC} ~ " ; grep 'PRETTY' /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '"'
# active desktop enviornment with wmctrl
echo -ne "${RED}de${NC} ~ " ; wmctrl -m | grep 'Name:' | sed 's/Name: //g'
# gtk theme, if exist print name
echo -ne "${YELLOW}gtk${NC} ~ " ; grep 'gtk-theme-name' ~/.config/gtk-3.0/* | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'
# cpu with lscpu
echo -ne "${GREEN}cpu${NC} ~ " ; lscpu | grep 'Model\ name' | sed 's/^[Model name:.* \t]*//'
# installed packages from package manager
echo -ne "${CYAN}pkgs${NC} ~ " ; pacman -Q | wc -l
# MemTotal in /proc/meminfo
echo -ne "${BLUE}ram${NC} ~ " ; grep 'MemTotal:' /proc/meminfo | sed 's/MemTotal://g' | sed 's/^[ \t]*//' 
# TERM info from printenv
echo -ne "${PURPLE}term${NC} ~ " ; printenv | grep -w 'TERM' | sed 's/TERM=//g'
