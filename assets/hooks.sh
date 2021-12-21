#!/bin/bash

# set src directory
[[ -e sysfetch ]] && src=$(dirname "$(readlink -f "$0")") || src="/usr/share/sysfetch"

# wrappers functions to test for command, directory and if variable exist
is() {
	[[ $1 = $2 ]]
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

# define colors
nc='\033[0m'
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;34m'
purple='\033[1;35m'
cyan='\033[1;36m'

# wrapper function to write given values and color
write() {
	is $3 red && color=$red
	is $3 green && color=$green
	is $3 yellow && color=$yellow
	is $3 blue && color=$blue
	is $3 purple && color=$purple
	is $3 cyan && color=$cyan
	end="\033[0m"
	printf "$color$1$end ~ $2"
}
