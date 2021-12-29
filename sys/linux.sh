#/bin/bash

# get hooks
[[ -e sysfetch ]] && source "assets/hooks.sh" || source "/usr/share/sysfetch/assets/hooks.sh"

# /USER/ get username from $USER environment variable or from id command
user=${USER:-$(id -un)}

# /HOST/ get hostname from $HOSTNAME or $hostname environment variables then uname
hostname=${HOSTNAME:-$hostname:-$host}

# /UPTIME/ convert raw seconds from /proc/uptime
d="/proc/uptime"
if dir $d ; then
	read -r sec < $d
	sec=${sec//.*}
	sec=${sec%\.*}
	days=$((sec/86400))
	hrs=$((sec%86400/3600))
	mins=$((sec%3600/60))
	if is $days 0 ; is $hrs "0" ; then
		uptime="$mins mins"
	elif is $days 0 ; then
		uptime="$hrs hrs, $mins mins"
	else
		uptime="$days days, $hrs hrs, $mins mins"
	fi
elif comm uptime ; then
	uptime=$(uptime | awk '{print $3}')
	uptime=${uptime//,}
fi

# /KERNEL/ get kernel from uname or /proc/version
kernel_rel=${kernel_rel:-$(awk '{print $3}' /proc/version)}

# /DISTRO/ check os-release for distrobution
d="/etc/os-release" ;dir $d && read -r distro < $d ||
d="/etc/issue" ; dir $d && read -r line < $d ; distro=${line%%\\*}
	
distro=${distro//NAME=}
distro=${distro//'"'}
is $distro *Arch* && distro="$distro (btw)"

# /ARCH/ 
# taken from uname

# /TERM/ get terminal from 2nd field of pstree output (need new method)
while read -r line ; do
	case $line in
		PPid*) ppid=${line#PPid:} ;;
	esac
done < /proc/$PPID/status

while read -r line ; do
	case $line in
		*:*) term=${line##* } ;;
	esac
done < <(ps -f $ppid)

# /SHELL/ check shell environment variable
shell=${SHELL##*/}

# /DE/WM/ get desktop environment or window manager
if var $XDG_CURRENT_DESKTOP ; then
	de_wm=$XDG_CURRENT_DESKTOP
elif var $DESKTOP_SESSION ; then
	de_wm=$DESKTOP_SESSION
elif comm wmctrl ; then
	while read -r line ; do
		case $line in
			Name:*) de_wm=${line#Name: } ;;
		esac
	done < <(wmctrl -m)
elif comm xprop ; then
	while read -r line ; do
		case $line in
			_NET_WM_NAME*) line=${line##*=} ; de_wm=${line//\"} ;;
		esac
	done < <(xprop -root)
fi

# /THEME/ stat theme {needs more methods}
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
	theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
	theme=${theme//"'"}
fi
theme=${theme##*=}
theme=${theme/-/ }

# /PKGS/ return package count - try not to use package manager, it's slow
if comm pacman ; then
	pacman=$(ls /var/lib/pacman/local | wc -l)
	src_pkgs=$(ls /usr/local/bin | wc -l)
	pkgs="$pacman (pacman) $src_pkgs (src)"
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
d="/proc/cpuinfo"
cpu_strip="s/Processor//;s/CPU//;s/(TM)//;s/(R)//;s/@//;s/ *$//"
while read -r line ; do
	case $line in
		vendor*) cpu_vendor=${line#*:} ;;
		model*) if is $cpu_vendor GenuineIntel ; then
			line=${line#*:} ; line=${line::7} ; cpu=$(sed "$cpu_strip" <<< $line) 
			else
			line=${line#*:} ; cpu=$(sed "$cpu_strip" <<< $line)
			fi ;;
	esac
done < $d

d="/sys/devices/system/cpu/cpu0/cpufreq"
if dir $d ; then
read -r max_cpu < $d/scaling_max_freq
read -r cur_cpu < $d/scaling_cur_freq
max_cpu=${max_cpu::-5}
max_cpu=$(sed 's/.$/.&/' <<< $max_cpu)
cur_cpu=${cur_cpu::-4}
cur_cpu=$(sed 's/..$/.&/' <<< $cur_cpu)
fi

# /GPU/ strip common prefixes from output of lspci
gpu_strip="s/Advanced Micro Devices, Inc. //;s/NVIDIA//;s/Corporation//;s/Controller//;s/controller//;s/storage//;s/filesystem//;s/Family//;s/Processor//;s/Mixture//;s/Model//;s/Generation/Gen/;s/^ *//"
comm lspci &&
while read -r line ; do
	case $line in
		*VGA*) line=${line##*:} ; gpu=$(sed "$gpu_strip" <<< $line) ;;
		*3D*) line=${line##*:} ; gpu=$(sed "$gpu_strip" <<< $line) ;;
	esac
done < <(lspci) 

# /MOBO/ return motherboard vendor + name
d="/sys/devices/virtual/dmi/id"
mobo_strip="s/COMPUTER INC.//"
if dir $d ; then
	read -r mobo_vendor < $d/board_vendor
	read -r mobo_name < $d/board_name
	mobo="$mobo_vendor $mobo_name"
	mobo=$(sed "$mobo_strip" <<< $mobo)
fi

# /DISK/ return device name, root partition size and output disk usage
comm df &&
while read -r line ; do
	case $line in
		*) dis=${line#*G }
			cur_disk=${dis%%G *}
			dis=${line%%G*}
			max_disk=${dis##* }
			dis=${line##*G}
			disk_per=${dis% *}
			;;
		*nvme*|*mmcblk*|*loop*) root=$(sed 's/p[0-9]*$//' <<< $line) ;;
		*sd*|*vd*|*sr*) root=${line%% *} ; root=$(sed 's/[0-9]*$//' <<< $line) ;;
	esac
done < <(df -h /)
disk_strip="s/ SSD//;s/ [0-9]*GB$//"
comm lsblk && disk_model=$(lsblk -n $root -io MODEL | sed "$disk_strip" | head -n1)


# /RAM/ get memory kb from meminfo
d="/proc/meminfo" ; dir $d &&
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

# /SWAP/ combine two swaps into one
d="/proc/swaps"
if dir $d ; then
cur_swap=$(awk 'FNR==2 {print $4/1024}' $d)
cur_swap2=$(awk 'FNR==3 {print $4/1024}' $d)
cur_swap=$(awk "BEGIN {print ${cur_swap1:-0}+${cur_swap2:-0}}")
max_swap=$(awk 'FNR==2 {print $3/1024}' $d)
max_swap2=$(awk 'FNR==3 {print $3/1024}' $d)
max_swap=$(awk "BEGIN {print ${max_swap:-0}+${max_swap2:-0}}")
fi
