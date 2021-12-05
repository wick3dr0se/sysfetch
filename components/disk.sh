#!/bin/bash

if [[ $(command -v df) ]] ; then
	echo -e "${YELLOW}disk${NC} ~ ${GREEN}$disk_cur${NC}${RED}/${NC}${BLUE}$disk_max${NC} MiB ${GREEN}$disk_per${NC}%"
fi
