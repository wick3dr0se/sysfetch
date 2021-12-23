#!/bin/bash

# get hooks
[[ -e sysfetch ]] && source "assets/hooks.sh" || source "/usr/share/sysfetch/assets/hooks.sh"

# /USER@HOST/
user="$USER"

# /HOST/ get hostname from $HOSTNAME or $hostname environment variables then uname
hostname=${HOSTNAME:-$hostname:-$host}

# UPTIME /
d="/proc/uptime"
if dir $d ; then
	read -r sec < $d
	sec=${sec//.*}
	sec=${sec%\.*}
	days=$((sec/86400))
	hrs=$((sec%86400/3600))
	mins=$((sec%3600/60))
	if is "$days" "0" ; is $hrs "0" ; then
		uptime="$mins mins"
	elif is "$days" "0" ; then
		uptime="$hrs hrs, $mins mins"
	else
		uptime="$days days, $hrs hrs, $mins mins"
	fi
elif comm uptime ; then
	uptime=$(uptime | awk '{print $3}' | tr -d ',')
fi

# /KERNEL/
# taken from uname

# /DISTRO/ check os-release for distrobution
d="/etc/os-release"
if dir $d ; then
	read -r distro < $d
elif dir /etc/issue ; then
	distro=$(awk -F\\ '{print $1}' /etc/issue | sed 's/ $//')
fi
distro=${distro//NAME=}
distro=${distro//'"'}

# /ARCH/
# taken from uname

# /TERM/
comm pstree && term=$(pstree -sA $$ | awk -F--- '{print $3 ; exit}')
term=${term/-/ }

# /SHELL/
var $SHELL && shell=${SHELL##*/}

# /DE_WM/
if var $XDG_CURRENT_DESKTOP ; then
	de_wm=$XDG_CURRENT_DESKTOP
elif var $DESKTOP_SESSION ; then
	de_wm=$DESKTOP_SESSION
elif comm wmctrl ; then
	de_wm=$(wmctrl -m | awk -F ': ' '/Name/ {print $2}')
elif dir /usr/share/xsession ; then
	de_wm=$(awk -F= '/Name/ {print $2}' /usr/share/xsessions/* | tail -n1)
elif dir /usr/share/wayland-session ; then
	de_wm=$(awk -F= '/Name/ {print $2}' /usr/share/wayland-sessions/*)
elif comm xprop ; then
	id=$(xprop -root | awk -F '# ' '/WM_CHECK/ {print $2}')
	de_wm=$(xprop -id $id 2>/dev/null | awk -F '"' '/WM_NAME/ {print $2}')
fi
# /THEME/
d=".config/gtk-3.0/settings.ini"
if dir ~/$d ; then
	while read -r line ; do
		case $line in
			gtk-theme*) theme=$line ;;
			### maybe we should output icons?
			gtk-icon*) icons=$line ;;
		esac
	done < ~/$d
elif comm gsettings ; then
	theme=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
fi
theme=${theme##*=}
theme=${theme/-/ }

# /PKGS/ return package count
if comm pacman ; then
	pacman=$(pacman -Qn | wc -l)
	aur=$(pacman -Qqm | wc -l)
	compiled=$(ls /usr/local/bin | wc -l)
	pkgs="$pacman (pacman) $aur (aur) $compiled (src)"
elif comm dpkg-query ; then
	pkgs="$(dpkg-query -l | wc -l)"
elif comm dnf ; then
	pkgs=$(dnf list installed | grep ".@." -c)
elif comm rpm ; then
	pkgs=$(rpm -qa | wc -l)
elif dir /var/log/packages ; then
	pkgs=$(ls /var/log/packages | wc -l)
elif comm opkg ; then
	pkgs=$(opkg list-installed | wc -w)
elif comm emrge ; then
	pkgs=$(ls -d /var/db/pkg/*/* | wc -l)
elif comm xbps-query ; then
	pkgs=$(xbps-query -l | grep -c '^li')
elif comm guix ; then
	pkgs=$(guix package --list-installed | wc -l)
elif comm nixos-rebuild ; then
	pkgs=$(ls /run/current-system/sw/bin | wc -l)
fi

# /CPU/ get cpu vendor and frequency
d="/proc/cpuinfo"
dir $d && cpu_vendor=$(awk -F ': ' '/vendor/ {print $2 ; exit}' $d)
cpu_strip="s/Processor//;s/CPU//;s/(TM)//;s/(R)//;s/@//;s/ *$//"
if is $cpu_vendor "GenuineIntel" ; then
	cpu=$(awk -F ': ' '/name/ {print $2 ; exit}' $d | sed "$cpu_strip;s/.......$//" | xargs)
else
	cpu=$(awk -F ': ' '/name/ {print $2 ; exit}' $d | sed "$cpu_strip" | xargs)
fi

cur_cpu="$(awk -v freq="$(wmic.exe cpu get currentclockspeed | sed -n 2p)" 'BEGIN {printf "%.2f", freq/1000}')"
max_cpu="$(awk -v freq="$(wmic.exe cpu get maxclockspeed | sed -n 2p)" 'BEGIN {printf "%.2f", freq/1000}')"

# /GPU/
gpu="$(wmic.exe path win32_VideoController get name | sed -n 2p)"
# /MOBO/
mobo="$(wmic.exe baseboard get product,Manufacturer | sed -n 2p | awk -F ' ' '{print $1, $2}')"
# /DISK/ return device name, root partition size and output disk usage
windir="$(cmd.exe /c echo %windir% 2> /dev/null)"
disk_name="${windir%%\\*}"
sizes="$(wmic.exe logicaldisk where "name='$disk_name'" get size, freespace | sed -n 2p)"
max_disk="$(awk '{print $2/1024/1024/1024}' <<< $sizes)"
cur_disk="$(awk '{print ($2-$1)/1024/1024/1024}' <<< $sizes)"
disk_per="$(awk '{print ($2-$1)/$2*100}' <<< $sizes)"

# /RAM/ get memory kb from meminfo
d="/proc/meminfo"
if dir $d ; then
	while read -r line ; do
		case $line in
			Active:*) cur_ram=${line#*:} ;;
			MemTot*) max_ram=${line#*:} ;;
		esac
	done < $d
	cur_ram=${cur_ram::-2}
	max_ram=${max_ram::-2}
	cur_ram=$((cur_ram/1024))
	max_ram=$((max_ram/1024))
fi

# /SWAP/
d="/proc/swaps"
if dir $d ; then
cur_swap=$(awk 'FNR==2 {print $4/1024}' $d)
cur_swap2=$(awk 'FNR==3 {print $4/1024}' $d)
cur_swap=$(awk "BEGIN {print ${cur_swap1:-0}+${cur_swap2:-0}}")
max_swap=$(awk 'FNR==2 {print $3/1024}' $d)
max_swap2=$(awk 'FNR==3 {print $3/1024}' $d)
max_swap=$(awk "BEGIN {print ${max_swap:-0}+${max_swap2:-0}}")
fi
