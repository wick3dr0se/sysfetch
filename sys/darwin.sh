#!/bin/bash

# get hooks
[[ -e /usr/share/sysfetch ]] ; source "/usr/share/sysfetch/assets/hooks.sh" || source "assets/hooks.sh"

# /USER/
user="$USER"

# /HOST/
#taken from uname

# UPTIME /
if dir /proc/uptime ; then
	read -r sec < /proc/uptime
	sec=${sec//.*}
	sec=${sec%\.*}
	days=$((sec/86400))
	hrs=$((sec%86400/3600))
	mins=$((sec%3600/60))
	if is $days "0" ; is $hrs "0" ; then
		uptime="$mins mins"
	elif is $days "0" ; then
		uptime="$hrs hrs, $mins mins"
	else
		uptime="$days days, $hrs hrs, $mins mins"
	fi
elif comm uptime ; then
	uptime=$(uptime | awk '{print $3}' | tr -d ',')
fi

# /KERNEL/
# taken from uname

# /DISTRO/
distro=$(sw_vers -productVersion)

# /ARCH/
# taken from uname

# /TERM/
term=${TERM_PROGRAM}

# /SHELL/
shell=$(SHELL##*/)

# /DE_WM/
de_wm="Aqua"

# /THEME/
simple_name=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')
theme=${simple_name}

# /PKGS/
dir /Applications ; pkgs=$(ls /Applications | wc -w | awk '{print $1}')
comm brew ; pkgs2=$(echo "brew:" ; ls /usr/local/Cellar | wc -w | awk '{print $1}')

# /CPU/
cpu=$(sysctl -n machdep.cpu.brand_string)

# /GPU/
gpu=$(system_profiler SPDisplaysDataType | grep Chipset | awk -F: '{print($2)}')

# /MOBO/
mobo=$(system_profiler SPHardwareDataType | awk 'FNR == 6 {print($3)}')

# /DISK/

# /RAM/
cur_ram=$(top -l 1 -s 0 | grep PhysMem | awk '{print($2)}' | sed 's/.$//')
max_ram=$(hostinfo | awk 'FNR == 8 {print($4)}' | sed 's/...$//')
ram="$cur_ram\M$max_ram\G"

# /SWAP/
swap=$(sysctl vm.swapusage | awk -F: '{print($2)}' | sed 's/.(encrypted)$//')
