#!/bin/bash

# set src directory
src=$(dirname "$(readlink -f "$0")")
[[ -e /usr/share/sysfetch ]] ; src="/usr/share/sysfetch"

# wrappers functions to test for command, directory and if variable exist
is() {
	[[ $1 == "$2" ]]
}
comm() {
	[[ $(command -v $1) ]]
}
dir() {
	[[ -e $1 ]]
}
var() {
	[[ ! -z $1 ]]
}

# wrapper function to echo given values
write() {
	if var $4 ; then
		echo -e "$1 ~ $2 \e \e \e\ $3 ~ $4"
	elif var $2 ; then
		echo -e "$1 ~ $2"
	else
		echo -e "$1"
	fi
}

