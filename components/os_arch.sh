#!/bin/bash
# // OS // ARCH // get os from /etc/os-release if exist; use uname for architecture
if [[ ! -z  $os ]] ; then
	echo -ne "${GREEN}os${NC} ~ $os \e \e \e \e "
else
	echo -ne "${GREEN}os${NC} ~ not found \e \e \e \e "
fi
if [[ $(command -v uname) ]] ; then
        echo -e "${RED}arch${NC} ~ $arch"
else
        echo -ne "\n"
fi
