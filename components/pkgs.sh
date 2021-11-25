#!/bin/bash


# // PKGS // if package manager found run query
echo -ne "${CYAN}pkgs${NC} ~ "
if [[ $(command -v pacman) ]] ; then
        pacman -Q | wc -l
elif [[ $(command -v dpkg-query) ]]; then
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
elif [[ $(command -v xbps-query) ]]; then
        xbps-query -l | grep -c '^ii'
else
        echo "pkgs not found"
fi


# // GUIX PKGS // seperate count for GUIX packages:
if [[ $(command -v guix) ]] ; then
        echo -ne "${YELLOW}GUIX pkgs${NC} ~ "
        guix package --list-installed | wc -l
fi


# // NIX PKGS // seperate count for NIX packages:
if [[ $(command -v nixos-rebuild) ]] ; then
        echo -ne "${PURPLE}NIX pkgs${NC} ~ "
        ls /run/current-system/sw/bin/ | wc -l
fi
