#!/bin/bash

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

script_path=$(dirname "$(readlink -f "$0")")

source "$script_path/components/host.sh"
source "$script_path/components/kernel.sh"
source "$script_path/components/uptime.sh"
source "$script_path/components/os_arch.sh"
source "$script_path/components/de-wm_theme.sh"
source "$script_path/components/cpu_gpu.sh"
source "$script_path/components/mobo.sh"
#source "$script_path/components/load.sh"
source "$script_path/components/pkgs.sh"
source "$script_path/components/ram_swap.sh"
source "$script_path/components/term_shell.sh"
