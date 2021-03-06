#!/bin/bash

shopt -s extglob

# defined function(s)
rmv() {
IFS=\'
for i in ${strip_regex[@]} ; do
	printf 's|%s||;' "$i"
done
}

# / USER / # check $USER environment var, then id -un command
user=${USER:-`id -un`}
# end / USER /

# / HOST / # check $HOSTNAME/$hostname environment vars, then uname
host=${HOSTNAME:-$hostname:-$host}
# end / HOST /

# / UPTIME / # convert raw seconds from /proc/uptime or use uptime command
p='/proc/uptime'
if [[ -f $p ]] ; then
	read s < $p
	s=${s/.*} ; sec=${s%\.*}
	days=$((sec/86400))
	hrs=$((sec%86400/3600))
	mins=$((sec%3600/60))
	if [[ $days = 0 && $hrs = 0 ]] ; then
		uptime="$mins mins"
	elif [[ $days = 0 ]] ; then
		uptime="$hrs hrs, $mins mins"
	else
		uptime="$days days, $hrs hrs, $mins mins"
	fi
elif [[ `command -v uptime` ]] ; then
	uptime=`uptime | awk '{print $3}'`
	uptime=${uptime/,}
fi
# end / UPTIME /

# / KERNEL / # get kernel from uname or from /proc/version
kernel_rel=${kernel_rel:-`awk '{print $3}' /proc/version`}
# end / KERNEL /

# / ARCH / # taken from global variables
# uname
# end / ARCH /

# / DISTRO / # check (/etc|/usr/lib)/os-release or /etc/issue for distrobution
for p in /etc/os-release /usr/lib/os-release ; do
	while read line ; do
		case $line in
			NAME*|PRE*) d=${line#*\"} && distro=${d/\"} && break ;;
		esac
      	done < $p
done

[[ ! $distro ]] && read line < '/etc/issue' && distro=${line%% r*}

[[ $distro =~ Arch ]] && distro="$distro (btw)"
# end / DISTRO /

# / TERM / # get terminal from parent process (needs work)
if [[ $DISPLAY ]] ; then
	p="/proc/${PPID}/status"
	[[ -f $p ]] &&
	while read line ; do
		case $line in
			PPid*) ppid=${line#*:} && break ;;
		esac
	done < $p

	[[ `command -v ps` ]] &&
	while read line ; do
		read line
		term=${line##* }
		break
	done < <(ps -f $ppid)
fi
# end / TERM /

# / SHELL / # check $SHELL environment var
shell=${SHELL##*/}
# end / SHELL /

# / DE WM / # check environment variables, then wmctrl command or xprop (needs work)
if [[ $XDG_CURRENT_DESKTOP ]] ; then
	dewm=$XDG_CURRENT_DESKTOP
elif [[ $DESKTOP_SESSION ]] ; then
	dewm=$DESKTOP_SESSION
elif [[ `command -v wmctrl` ]] ; then
	while read line ; do
		case $line in
			Name:*) dewm=${line#*: } && break ;;
		esac
	done < <(wmctrl -m)
elif [[ $DISPLAY && `command -v xprop`  ]] ; then
	while read line ; do
		case $line in
			*_NET_WM_NAME*) line=${line##*=} && dewm=${line/\"} && break ;;
		esac
	done < <(xprop -root)
fi
# end / DE WM /

# / THEME / stat theme (needs work)
p='.config/gtk-3.0/settings.ini'
if [[ -f ~/${p} ]] ; then
	while read line ; do
		case $line in
			*gtk-theme*) theme=$line && break ;;
		esac
	done < ~/$p
elif [[ `command -v gsettings` ]] ; then
	theme=`gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null`
	theme=${theme//\'}
fi
theme=${theme##*=}
theme=${theme/-/ }
# end / THEME /

# / PKGS / get package count; prefer ls over using package manager
if [[ -d /var/lib/pacman/local ]] ; then
	pacman=`ls /var/lib/pacman/local | wc -l`
	src_pkgs=`ls /usr/local/bin | wc -l`
	pkgs="$pacman (pacman) $src_pkgs (src)"
elif [[ `command -v dpkg-query` ]] ; then
	pkgs=`dpkg-query -l | wc -l`
elif [[ `command -v dnf` ]] ; then
	pkgs=`dnf list installed | grep '.@.' -c`
elif [[ `command -v rpm` ]] ; then
	pkgs=`rpm -qa | wc -l`
elif [[ -d var/log/packages ]] ; then
	pkgs=`ls /var/log/packages | wc -l`
elif [[ `command -v opkg` ]] ; then
	pkgs=`opkg list-installed | wc -w`
elif [[ `command -v emerge` ]] ; then
	pkgs=`ls -d '/var/db/pkg/*/*' | wc -l`
elif [[ `command -v xbps-query` ]] ; then
	pkgs=`xbps-query -l | grep -c '^li'`
elif [[ `command -v guix` ]] ; then
	pkgs=`guix package --list-installed | wc -l`
elif [[ `command -v nixos-rebuild` ]] ; then
	pkgs=`ls /run/current-system/sw/bin | wc -l`
fi
# end / PKGS /

# / CPU / # get vendor and model name from /proc/cpuinfo; strip it with regex
strip_regex=('Processor' 'CPU' '(TM)' '(R)' '@' ' [0-9]*\.[0-9]*GHz' ' *$')
while read line ; do
	case $line in
		vendor*) cpu_vendor=${line#*:} ;;
		model\ name*) if [[ $cpu_vendor = GenuineIntel ]] ; then
				line=${line#*:} && cpu=`sed "$(rmv)" <<< ${line::7}`
			else
				cpu=`sed "$(rmv)" <<< ${line#*:}`
			fi && break ;;
	esac
done < /proc/cpuinfo

# get max cpu frequency
p='/sys/devices/system/cpu/cpu0/cpufreq'
read max_cpu < "${p}/scaling_max_freq"
max_cpu=${max_cpu::-5}
max_cpu=`sed 's/.$/.&/' <<< $max_cpu`

# get current cpu frequency
read cur_cpu < "${p}/scaling_cur_freq"
cur_cpu=${cur_cpu::-4}
cur_cpu=`sed 's/..$/.&/' <<< $cur_cpu`
# end / CPU /

# / GPU / clean lspci output
strip_regex=('Advanced Micro Devices, Inc.' 'NVIDIA' 'Corporation' 'Controller' 'controller' 'storage' 'filesystem' 'Family' 'Processor' 'Mixture' 'Model' 'Generation' 'Gen' '^[[:space:]]*')
while read line ; do
	case $line in
		*VGA*) gpu=`sed "$(rmv)" <<< ${line##*:}` ;;
		*3D*) gpu2=`sed "$(rmv)" <<< ${line##*:}` && break ;;
	esac
done < <(lspci)
# end / GPU /

# / MOBO / # return motherboard vendor & name
strip_regex=('COMPUTER INC.')
p='/sys/devices/virtual/dmi/id'
read mobo_vendor < ${p}/board_vendor
read mobo_name < ${p}/board_name
mobo=`sed "$(rmv)" <<< "$mobo_vendor $mobo_name"`
# end / MOBO /

# / DISK / # get disk usage & disk model by regex
while read line ; do
	read part max_disk cur_disk x disk_per && disk="${cur_disk}/${max_disk} ${disk_per% *}"
	case $part in
		/dev/+(sd*|vd*|sr*)) dis=`sed 's/[0-9]*$//' <<< $part` ;;
		/dev/+(nvme*|mmcblk*)) dis=`sed 's/p[0-9]*$//' <<< $part` && break ;;
	esac
done < <(df -h /)

strip_regex=('SSD' '[0-9*GB$]')
[[ `command -v lsblk` ]] && disk_model=`lsblk $dis -no MODEL | sed "$(rmv)"`
# end /DISK /

# / RAM / convert kb from meminfo
while read line ; do
	case $line in
		MemTot*) line=${line#*:} && max_ram=$((${line% kB}/1024)) ;;
		Active:*) line=${line#*:} && cur_ram=$((${line% kB}/1024)) && break ;;
	esac
done < /proc/meminfo
ram="${cur_ram}/${max_ram}M"
# end / RAM /

# / SWAP / convert kB from /proc/swaps, then combine two swaps if found
while read -a line ; do
	read -a line1
	read -a line2
	if [[ $line2 ]] ; then
		cur_swap=$((${line1[3]+${line2[3]}}/1024))
		max_swap=$((${line1[2]+${line2[2]}}/1024))
	elif [[ $line1 ]] ; then
		cur_swap=$((${line1[3]}/1024))
		max_swap=$((${line1[2]}/1024))
	fi
	break
done < /proc/swaps
swap="${cur_swap}/${max_swap}M"
# end / SWAP /
