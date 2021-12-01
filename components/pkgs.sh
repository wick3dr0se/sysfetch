#!/bin/bash

# // PKGS // if package manager found run query
echo -ne "${BLUE}pkgs${NC} ~ "
if [[ $(command -v pacman) ]] ; then
	pacman -Q | wc -l
elif [[ $(command -v dpkg-query) ]] ; then
	dpkg-query -l | grep -c '^ii'
elif [[ $(command -v dnf) ]] ; then
	dnf list installed | grep ".@." -c
elif [[ $(command -v rpm) ]] ; then
	rpm -qa | wc -l
elif test -e /var/log/packages ; then
	ls /var/log/packages | wc -l
elif [[ $(command -v opkg) ]] ; then
	opkg list-installed | wc -w
elif [[ $(command -v emerge) ]] ; then
	ls -d /var/db/pkg/*/* | wc -l
elif [[ $(command -v xbps-query) ]] ; then
	xbps-query -l | grep -c '^ii'
# seperate pkg count
elif [[ $(command -v guix) ]] ; then
	echo -ne "${YELLOW}GUIX pkgs${NC} ~ "
	guix package --list-installed | wc -l
elif [[ $(command -v nixos-rebuild) ]] ; then
	echo -ne "${PURPLE}NIX pkgs${NC} ~ "
	ls /run/current-system/sw/bin/ | wc -l
elif [[ -e /Applications ]] ; then
	echo -ne "${BLUE}pkgs${NC} ~ "
	ls /Applications | wc -w | awk '{print($1)}'
elif [[ $(command -v brew) ]] ; then
	echo -ne "${RED}brewpkgs${NC} ~"
	ls /usr/local/Cellar | wc -w | awk '{print($1)}'
else
	echo "not found"
fi
