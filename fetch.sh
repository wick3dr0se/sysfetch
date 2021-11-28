#!/bin/bash

# colors
NC='\033[0m'
BLACK='\033[1;30m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'


# // HOST // get hostname from uname & username from $USER variable
if [[ $(command -v uname) ]] ; then
host=$(uname -n)
user=$(echo $USER)
	echo -e "${PURPLE}$host${NC}@${BLUE}$user${NC}"
fi


# // OS // ARCH // get os from /etc/os-release if exist; use uname for architecture
[[ -e /etc/os-release ]] ; os=$(awk -F '"' '/PRETTY/ {print $2}' /etc/os-release) ; echo -ne "${GREEN}os${NC} ~ $os \e \e \e \e "
[[ $(command -v uname) ]] ; arch=$(uname -m) ; echo -e "${RED}arch${NC} ~ $arch"


# // UPTIME //
if [[ -e /proc/uptime ]] ; then
sec=$(awk '{print $1}' /proc/uptime)
sec=${sec%\.*}
        echo -ne "${CYAN}uptime${NC} ~ "
        printf '%d days, %d hours, %d minutes \n' $(($sec/86400)) $(($sec%86400/3600)) $(($sec%3600/60))
fi


# // KERNEL // w/ uname
echo -ne "${YELLOW}kernel${NC} ~ "
uname -r


# // TERM // get terminal name w/ pstree
if [[ ! -z $term ]] ; then
init_strip="s/init//g;s/systemd//g"
term=$(pstree -sA $$ 2>/dev/null | head -n1 | sed "s/head//g;s/fetch.sh//g;$init_strip;$shell_strip;s/^-*//;s/+//;s/-*$//")
        echo -ne "${RED}term${NC} ~ $term \e \e \e \e "
elif [[ ! -z "$TERM" ]] ; then
        echo -ne "${YELLOW}term${NC} ~ $TERM \e \e \e \e "
else
        echo -ne "not found"
fi

# // SHELL // echo '$SHELL' enviornment variable
if [[ ! -z "$SHELL" ]] ; then
shell=$(echo "$SHELL" | sed 's%.*/%%')
	echo -e "${BLUE}shell${NC} ~ $shell"
fi


# // DE/WM // search xsessions, then wayland-sessions, fallback on xprop
dewm="${PURPLE}de/wm${NC} ~ "
if [[ ! -z "$XDG_CURRENT_DESKTOP" ]] ; then
session=$(echo $XDG_CURRENT_DESKTOP)
        echo -ne "$dewm"
        echo -n "$session"
elif [[ -e /usr/share/xsessions/ ]] ; then
        echo -ne "$dewm"
        head /usr/share/xsessions/* | grep -im1 'names=' | sed 's/DesktopNames=//;s/CLASSIC//;s/Ubuntu//;s/ubuntu//;s/Classic//;s/GNOME//2g' | tr -d ':-;\n'
elif [[ -e /usr/share/wayland-sessions/ ]] ; then
        echo -ne "$dewm"
        head /usr/share/wayland-sessions/* | grep -im1 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
elif [[ $(command -v xprop) ]] && [[ ! -z $DISPLAY ]] ; then
        id=$(xprop -root 2>/dev/null | sed -n '/^_NET_SUPPORTING_WM_CHECK/ s/.* // p')
        echo -ne "$dewm"
        echo $(xprop -id "$id" | sed -n '/^_NET_WM_NAME/ s/.* // p' | sed 's/"//g') | tr -d "\n"
else
        echo -ne "$dewm"
        echo -n "not found"
fi



# // THEME // get theme name from settings.ini if variable exist, if not found print output to /dev/null. stat gsettings if variable found 
echo -ne " \e \e \e \e ${YELLOW}theme${NC} ~ "
if [[ -e ~/.config/gtk-3.0/settings.ini ]] ; then
gtk_name=$(grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | sed 's/gtk-theme-name=//g' | sed 's/-/ /g')
	echo "$gtk_name"
elif [[ $(command -v gsettings) ]] && [[ ! -z "theme_name" ]] ; then
theme_name=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
        echo "$theme_name"
fi



# // PKGS // if package manager found run query
echo -ne "${BLUE}pkgs${NC} ~ "
if [[ $(command -v pacman) ]] ; then
        pacman -Q | wc -l
elif [[ $(command -v dpkg-query) ]] ; then
        dpkg-query -l | grep -c '^ii'
elif [[ $(command -v dnf) ]] ; then
        dnf list installed | grep ".@." -c
elif [[ $(command -v rpm) ]] ; then
        rpm -qa | wc -l
elif test -e /var/log/packages ; then
        ls /var/log/packages | wc -l
elif [[ $(command -v opkg) ]] ; then
        opkg list-installed | wc -w
elif [[ $(command -v emerge) ]] ; then
        ls -d /var/db/pkg/*/* | wc -l
elif [[ $(command -v xbps-query) ]] ; then
        xbps-query -l | grep -c '^ii'
else
        echo "not found"
fi

# spereate count for GUIX/NIX pkgs
if [[ $(command -v guix) ]] ; then
        echo -ne "${YELLOW}GUIX pkgs${NC} ~ "
        guix package --list-installed | wc -l
elif [[ $(command -v nixos-rebuild) ]] ; then
        echo -ne "${PURPLE}NIX pkgs${NC} ~ "
        ls /run/current-system/sw/bin/ | wc -l
fi


# // CPU //
echo -ne "${CYAN}cpu${NC} ~ "
[[ -e /proc/cpuinfo ]] ; cpu_vendor=$(head /proc/cpuinfo | grep -m1 "vendor_id" | sed 's/vendor_id//' | tr -d '\t :')
if [[ $cpu_vendor == "GenuineIntel" ]] ; then
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/(TM)//;s/(R)//;s/@//;s/CPU//;s/^ *//;s/.......$//' | tr -d '\n'
else
	awk -F: '/model name/{print $2 ; exit}' /proc/cpuinfo | sed 's/Processor//;s/CPU//;s/^ *//' | tr -d '\n'
fi

# get cpu frequency from /sys/devices/system/cpu
max_cpufreq=$(head /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | sed 's/......$/.&/;s/.....$//')
cur_cpufreq=$(head /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | sed 's/......$/.&/;s/....$//')
if [[ ! -z $max_cpufreq ]] ; then
echo -ne "$max_cpufreq"
echo -ne "@${CYAN}$cur_cpufreq${NC}" ; echo "GHz"
fi


# // GPU // with lscpi
if [[ $(command -v lspci) ]] ; then
        echo -ne "${GREEN}gpu${NC} ~ "
        lspci | grep -im1 --color 'vga\|3d\|2d' | sed 's/VGA compatible controller//;s/Advanced Micro Devices, Inc//;s/NVIDIA Corporation//;s/Corporation//;s/Controller//;s/controller//;s/storage//;s/filesystem//;s/0000//;s/Family//;s/Processor//;s/Mixture//;s/Model//;s/Generation/Gen/g' | tr -d '.:[]' | sed 's/^.....//;s/^ *//' 
fi


# // MOBO // get motherboard vendor & name if exist
if [[ -e /sys/devices/virtual/dmi/id/board_name ]] ; then
mobo_vendor=$(head /sys/devices/virtual/dmi/id/board_vendor)
mobo_name=$(head /sys/devices/virtual/dmi/id/board_name)
	echo -ne "${YELLOW}mobo${NC} ~ "
        echo -e "$mobo_vendor $mobo_name"
fi


# // RAM // print 'MemTotal' in /proc/meminfo
echo -ne "${RED}ram${NC} ~ "
cur_ram=$(awk '/Active:/ {printf "%d/", $2 / 1024}' /proc/meminfo)
max_ram=$(awk '/MemTotal:/ {printf "%dMiB", $2 / 1024}' /proc/meminfo)
echo -n "$cur_ram$max_ram"

# // SWAP // print 'Size' from /proc/swaps
if [[ -e /proc/swaps ]] ; then
swap_count=$(head /proc/swaps | wc -l)
swap1_kb=$(sed -n '2p' /proc/swaps | awk '{print($3)}')
swap2_kb=$(sed -n '3p' /proc/swaps | awk '{print($3)}')
fi
if [[ "$swap_count" = "2" ]] ; then  
        let "swap1_mb = $swap1_kb / 1024"
        echo -ne " \e \e \e \e ${PURPLE}swap${NC} ~ "
        echo "$swap1_mb MiB"     
elif [[ "$swap_count" -ge "3" ]] ; then 
        let "swap1_mb = $swap1_kb / 1024"
        echo -ne " \e \e \e \e ${PURPLE}swap${NC} ~ "
        echo -ne "$swap1_mb MiB " | sed 's/ //'
        let "swap2_mb = $swap2_kb / 1024"
        echo "$swap2_mb MiB" | sed 's/ //'
fi



# // LOAD AVGS // w shell redirect into awk
#echo -ne "${PURPLE}load${NC} ~ "
#[[ -e /proc/loadavg ]] ; head /proc/loadavg
