#!/bin/bash

# /USER/ get username from $USER environment variable or from id command
_user() {
	user="${USER:-$(id -un)}"
}

# /HOST/ get hostname from $HOSTNAME or $hostname environment variables then uname
_host() {
	hostname="${HOSTNAME:-$hostname:-$host}"
}

# /UPTIME/ convert raw seconds from /proc/uptime
_uptime() {
	p='/proc/uptime'
	if [[ -f "${p}" ]]; then
		read sec <"${p}"
		sec="${sec//.*/}"
		sec="${sec%\.*}"
		days="$((sec / 86400))"
		hrs="$((sec % 86400 / 3600))"
		mins="$((sec % 3600 / 60))"
		if [[ "${days}" = '0' && "${hrs}" = '0' ]]; then
			uptime="${mins} mins"
		elif [[ "${days}" = '0' ]]; then
			uptime="${hrs} hrs, ${mins} mins"
		else
			uptime="${days} days, ${hrs} hrs, ${mins} mins"
		fi
	elif [[ $(command -v uptime) ]]; then
		uptime="$(uptime | awk '{print $3}')"
		uptime="${uptime//,/}"
	fi
}

# /KERNEL/ get kernel from uname or /proc/version
_kernel() {
	kernel_rel="${kernel_rel:-$(awk '{print $3}' '/proc/version')}"
}

# /DISTRO/ check os-release for distrobution
_distro() {
	if [[ -f '/etc/os-release' ]]; then
		read distro <'/etc/os-release'
	elif [[ -f '/etc/issue' ]]; then
		read distro <'/etc/issue'
		distro="${distro// r*/}"
	fi
	distro="${distro//NAME=/}"
	distro="${distro//\"/}"
}

# /ARCH/
# taken from uname

# /TERM/ get terminal from 2nd field of pstree output (need new method)
_term() {
	p="/proc/${PPID}/status"
	if [[ -f "${p}" ]]; then
		while read line; do
			case "${line}" in
			'PPid'*)
				line="${line#PPid:}"
				ppid="$(xargs <<<${line})"
				;;
			esac
		done <"${p}"
	fi
	if [[ $(command -v ps) ]]; then
		while read line; do
			case "${line}" in
			*':'*) term="${line##* }" ;;
			esac
		done < <(ps -f "${ppid}")
	fi
}

# /SHELL/ check shell environment variable
_shell() {
	shell="${SHELL##*/}"
}

# /DE/WM/ get desktop environment or window manager
_de_wm() {
	if [[ ! -z "${XDG_CURRENT_DESKTOP}" ]]; then
		de_wm="${XDG_CURRENT_DESKTOP}"
	elif [[ ! -z "${DESKTOP_SESSION}" ]]; then
		de_wm="${DESKTOP_SESSION}"
	elif [[ $(command -v wmctrl) ]]; then
		while read line; do
			case "${line}" in
			'Name:'*) de_wm="${line#Name: }" ;;
			esac
		done < <(wmctrl -m)
	elif [[ $(command -v xprop) ]]; then
		while read line; do
			case "${line}" in
			'_NET_WM_NAME'*)
				line="${line##*=}"
				de_wm="${line//\"/}"
				;;
			esac
		done < <(xprop -root)
	fi
}

# /THEME/ stat theme {needs more methods}
_theme() {
	p='.config/gtk-3.0/settings.ini'
	if [[ -f "~/${p}" ]]; then
		while read line; do
			case "${line}" in
			gtk-theme*) theme="${line}" ;;
			### maybe we should output icons?
			gtk-icon*) icons="${line}" ;;
			esac
		done <"~/${p}"
	elif [[ $(command -v gsettings) ]]; then
		theme="$(gsettings get org.gnome.desktop.interface gtk-theme)"
		theme="${theme//\'/}"
	fi
	theme="${theme##*=}"
	theme="${theme/-/ }"
}

# /PKGS/ return package count - try not to use package manager, it's slow
_pkgs() {
	if [[ -d '/var/lib/pacman/local' ]]; then
		pacman="$(ls '/var/lib/pacman/local' | wc -l)"
		src_pkgs="$(ls '/usr/local/bin' | wc -l)"
		pkgs="${pacman} (pacman) ${src_pkgs} (src)"
	elif [[ $(command -v dpkg-query) ]]; then
		pkgs="$(dpkg-query -l | wc -l)"
	elif [[ $(command -v dnf) ]]; then
		pkgs="$(dnf list installed | grep ".@." -c)"
	elif [[ $(command -v rpm) ]]; then
		pkgs="$(rpm -qa | wc -l)"
	elif [[ -d '/var/log/packages' ]]; then
		pkgs="$(ls '/var/log/packages' | wc -l)"
	elif [[ $(command -v opkg) ]]; then
		pkgs="$(opkg list-installed | wc -w)"
	elif [[ $(command -v emrge) ]]; then
		pkgs="$(ls -d '/var/db/pkg/*/*' | wc -l)"
	elif [[ $(command -v xbps-query) ]]; then
		pkgs="$(xbps-query -l | grep -c '^li')"
	elif [[ $(command -v guix) ]]; then
		pkgs="$(guix package --list-installed | wc -l)"
	elif [[ $(command -v nixos-rebuild) ]]; then
		pkgs="$(ls '/run/current-system/sw/bin' | wc -l)"
	fi
}

# /CPU/ get cpu vendor and frequency
_cpu() {
	cpu_strip='s/Processor//;s/CPU//;s/(TM)//;s/(R)//;s/@//;s/ [0-9]*\.[0-9]*GHz//;s/ *$//;'
	while read line; do
		case "${line}" in
		'vendor'*) cpu_vendor="${line#*:}" ;;
		'model'*) if [[ "${cpu_vendor}" = 'GenuineIntel' ]]; then
			line="${line#*:}"
			line="${line::7}"
			cpu="$(sed "${cpu_strip}" <<<${line})"
		else
			line="${line#*:}"
			cpu="$(sed "$cpu_strip" <<<${line})"
		fi ;;
		esac
	done <'/proc/cpuinfo'
}

_cpu_freq() {
	cur_cpu="$(awk -v freq="$(wmic.exe cpu get currentclockspeed | sed -n 2p)" 'BEGIN {printf "%.2f", freq/1000}')"
	max_cpu="$(awk -v freq="$(wmic.exe cpu get maxclockspeed | sed -n 2p)" 'BEGIN {printf "%.2f", freq/1000}')"
}

# /GPU/
_gpu() {
	gpu="$(wmic.exe path win32_VideoController get name | sed -n 2p)"
}
# /MOBO/
_mobo() {
	mobo="$(wmic.exe baseboard get product,Manufacturer | sed -n 2p | awk -F ' ' '{print $1, $2}')"
}
# /DISK/ return device name, root partition size and output disk usage
_disk() {
	windir="$(cmd.exe /c echo %windir% 2>/dev/null)"
	disk_name="${windir%%\\*}"
	sizes="$(wmic.exe logicaldisk where "name='$disk_name'" get size, freespace | sed -n 2p)"
	max_disk="$(awk '{print $2/1024/1024/1024}' <<<$sizes)"
	cur_disk="$(awk '{print ($2-$1)/1024/1024/1024}' <<<$sizes)"
	disk_per="$(awk '{print ($2-$1)/$2*100}' <<<$sizes)"
}

# /RAM/ get memory kb from meminfo
_ram() {
p='/proc/meminfo'
while read line ; do
	case "${line}" in
		'Active:'*) v="${line#*:}" ; v="${v//kB}" ; v="${v//.*}" ; cur_ram="$((${v}/1024))" ;;
		'MemTot'*) v="${line#*:}" ; v="${v//kB}" ; v="${v//.*}" ; max_ram="$((${v}/1024))" ;;
	esac
done < "${p}"
}

# /SWAP/ combine two swaps into one
_swap() {
p='/proc/swaps'
cur_swap="$(awk 'FNR==2 {print $4/1024}' "${p}")"
cur_swap2="$(awk 'FNR==3 {print $4/1024}' "${p}")"
cur_swap="$(awk "BEGIN {print "${cur_swap:-0}+${cur_swap2:-0}"}")" 
max_swap="$(awk 'FNR==2 {print $3/1024}' "${p}")"
max_swap2="$(awk 'FNR==3 {print $3/1024}' "${p}")"
max_swap="$(awk "BEGIN {print "${max_swap:-0}+${max_swap2:-0}"}")"
}
