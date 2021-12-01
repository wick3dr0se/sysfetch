#!/bin/bash
# // OS //
if [[ "$sys" = "Darwin" ]] ; then
	echo -ne "${GREEN}os${NC} ~ $(sw_vers -productVersion) "
elif [[ ! -z  $os ]] ; then
	echo -ne "${GREEN}os${NC} ~ $os \e \e \e \e "
else
	echo -ne "${GREEN}os${NC} ~ not found \e \e \e \e "
fi
# // ARCH //
if [[ $(command -v uname) ]] ; then
        echo -e "${RED}arch${NC} ~ $arch"	
else
        echo -ne "\n"
fi
