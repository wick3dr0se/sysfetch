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


#output errors to null
exec 2>/dev/null


# global variables

# system type check:
systype=$(uname)

# host
host=$(uname -n)
user=$(echo $USER)

# os_arch
os=$(awk -F '"' '/PRETTY/ {print $2}' /etc/os-release)
darwinsimplename=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')
arch=$(uname -m)

# uptime
sec=$(awk '{print $1}' /proc/uptime)
sec=${sec%\.*}

# term_shell
init_strip="s/login//g;s/startx//g;s/x//g;s/init//g;s/systemd//g"
de_strip="s/dwm//g"
shell_strip="s/fish//g;s/bash//g;s/zsh//g;s/ash//g"
term=$(pstree -sA $$ | head -n1 | sed "s/head//g;s/fetch.sh//g;$init_strip;$de_strip;$shell_strip;s/^-*//;s/+//;s/-*$//")
shell=$(echo "$SHELL" | sed 's%.*/%%')

#de/wm_theme
session=$(echo $XDG_CURRENT_DESKTOP)
gtk_name=$(grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | sed 's/gtk-theme-name=//g' | sed 's/-/ /g')
theme_name=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")

# cpu_gpu
cpu_vendor=$(head /proc/cpuinfo | grep -m1 "vendor_id" | sed 's/vendor_id//' | tr -d '\t :')
max_cpufreq=$(head /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | sed 's/......$/.&/;s/.....$//')
cur_cpufreq=$(head /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | sed 's/......$/.&/;s/....$//')

# mobo
mobo_vendor=$(head /sys/devices/virtual/dmi/id/board_vendor)
mobo_name=$(head /sys/devices/virtual/dmi/id/board_name)

# ram_swap
cur_ram=$(awk '/Active:/ {printf "%d/", $2 / 1024}' /proc/meminfo)
max_ram=$(awk '/MemTotal:/ {printf "%dMiB", $2 / 1024}' /proc/meminfo)
swap_count=$(head /proc/swaps | wc -l)
swap1_kb=$(sed -n '2p' /proc/swaps | awk '{print($3)}')
swap2_kb=$(sed -n '3p' /proc/swaps | awk '{print($3)}')


script_path=$(dirname "$(readlink -f "$0")")

source "$script_path/components/host.sh"
source "$script_path/components/uptime.sh"
source "$script_path/components/os_arch.sh"
source "$script_path/components/kernel.sh"
source "$script_path/components/term_shell.sh"
source "$script_path/components/de-wm_theme.sh"
source "$script_path/components/pkgs.sh"
source "$script_path/components/cpu_gpu.sh"
source "$script_path/components/mobo.sh"
source "$script_path/components/ram_swap.sh"
#source "$script_path/components/load.sh"
#source "$script_path/components/uptime.sh"
