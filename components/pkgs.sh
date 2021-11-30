#!/bin/bash

case $systype in

  Linux)

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
    else
          echo "not found"
    fi

    # separate count for GUIX/NIX pkgs
    if [[ $(command -v guix) ]] ; then
          echo -ne "${YELLOW}GUIX pkgs${NC} ~ "
          guix package --list-installed | wc -l
    elif [[ $(command -v nixos-rebuild) ]] ; then
          echo -ne "${PURPLE}NIX pkgs${NC} ~ "
          ls /run/current-system/sw/bin/ | wc -l
    fi
    ;;

  Darwin)

    # // PKGS //
    macpkgs=$(ls /Applications | wc -w | awk '{print($1)}')
          echo -ne "${BLUE}pkgs${NC} ~ $macpkgs"

    # // Homebrew PKGS // seperate count for homebrew packages.
    if [[ $(command -v brew)]] ; then
    brewpkgs=$(ls /usr/local/Cellar | wc -w | awk '{print($1)}')
          echo -ne "${RED}brewpkgs${NC} ~ $brewpkgs"
    fi
    ;;
    
esac
