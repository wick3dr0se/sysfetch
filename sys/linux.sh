#/bin/bash

# get hooks
[[ -e sysfetch ]] && source "assets/hooks.sh" || source "/usr/share/sysfetch/assets/hooks.sh"

# /USER@HOST/ get user and hostname
user=$(uname -n)
hostname="$USER"

# /UPTIME/ convert raw seconds from /proc/uptime
if dir /proc/uptime ; then
	read -r sec < /proc/uptime
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

# /KERNEL/ get kernel release
kernel=$(uname -r)

# /DISTRO/ check os-release for distrobution
for d in /etc/os-release /usr/lib/os-release ; do
	read -r d < $d
done
d=${d//NAME=}
distro=${d//'"'}
is "$distro" *"Arch"* && distro="$distro (btw)"

# /ARCH/ get architecture
arch=$(uname -m)

# /TERM/ get terminal from 2nd field of pstree output (need new method)
term=$(pstree -sA $$ | awk -F--- '{print $2 ; exit}')
term=${term/-/ }

# /SHELL/ check shell environment variable
shell=${SHELL##*/}

# /DE/WM/ get desktop environment or window manager
if var $XDG_CURRENT_DESKTO ; then
	de_wm=$XDG_CURRENT_DESKTOP
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

# /THEME/ stat theme {needs more methods}
if dir ~/.config/gtk-3.0/settings.ini ; then
	while read -r line ; do
		case $line in
			gtk-theme*) theme=$line ;;
			gtk-icon*) icons=$line ;;
		esac
	done < ~/.config/gtk-3.0/settings.ini
elif comm gsettings ; then
	theme=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
fi
theme=${theme##*=}
theme=${theme/-/ }

# /PKGS/ return package count
if comm pacman ; then
	pacman=$(pacman -Qn | wc -l)
	aur=$(pacman -Qqm | wc -l)
	pkgs="$pacman (pacman) $aur (aur)"
elif comm dpkg-query ; then
	pkgs=$(dpkg-query -l | grep -c '^li')
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
cpu_vendor=$(awk -F ': ' '/vendor/ {print $2 ; exit}' /proc/cpuinfo)
cpu_strip="s/Processor//;s/CPU//;s/(TM)//;s/(R)//;s/@//"
if is $cpu_vendor "GenuineIntel" ; then
	cpu=$(awk -F ': ' '/name/ {print $2 ; exit}' /proc/cpuinfo | sed "$cpu_strip;s/.......$//")
else
	cpu=$(awk -F ': ' '/name/ {print $2 ; exit}' /proc/cpuinfo | sed "$cpu_strip")
fi

read -r max_cpu < /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
read -r cur_cpu < /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
max_cpu=${max_cpu::-5}
max_cpu=$(sed 's/.$/.&/' <<< $max_cpu)
cur_cpu=${cur_cpu::-4}
cur_cpu=$(sed 's/..$/.&/' <<< $cur_cpu)

# /GPU/ strip common prefixes from output of lspci
gpu_strip="s/Advanced Micro Devices, Inc. //;s/NVIDIA//;s/Corporation//;s/Controller//;s/controller//;s/storage//;s/filesystem//;s/Family//;s/Processor//;s/Mixture//;s/Model//;s/Generation/Gen/;s/^ //"
gpu=$(lspci | awk -F ': ' '/VGA/ {print $2}' | sed "$gpu_strip" | tr -d '[]')

# /MOBO/ return motherboard vendor + name
read -r board_vendor < /sys/devices/virtual/dmi/id/board_vendor
read -r board_name < /sys/devices/virtual/dmi/id/board_name
mobo="$board_vendor $board_name"

# /DISK/ return root partition size
disk_strip="s/SSD//"
disk=$(lsblk -io MODEL | sed -n '2p' | sed 's/ SSD//')
cur_disk=$(df | grep -w '/' | awk '{print $3/1024}')
max_disk=$(df | grep -w '/' | awk '{print $2/1024}')
cur_disk=${cur_disk%\.*}
max_disk=${max_disk%\.*}
disk_per=$(df | grep -w '/' | awk '{print $5}')

# /RAM/ get memory kb from meminfo
while read -r line ; do
	case $line in
		Active:*) cur_ram=${line#*:} ;;
		MemTot*) max_ram=${line#*:} ;;
	esac
done < /proc/meminfo
cur_ram=${cur_ram::-2}
max_ram=${max_ram::-2}
cur_ram=$((cur_ram / 1024))
max_ram=$((max_ram / 1024))

# /SWAP/ combine two swaps into one
cur_swap=$(awk 'FNR==2 {print $4/1024}' /proc/swaps)
cur_swap2=$(awk 'FNR==3 {print $4/1024}' /proc/swaps)
cur_swap=$(awk "BEGIN {print ${cur_swap1:-0}+${cur_swap2:-0}}")
max_swap=$(awk 'FNR==2 {print $3/1024}' /proc/swaps)
max_swap2=$(awk 'FNR==3 {print $3/1024}' /proc/swaps)
max_swap=$(awk "BEGIN {print ${max_swap:-0}+${max_swap2:-0}}")
