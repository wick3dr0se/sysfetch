#!/bin/bash


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
white='\033[1;37m'
nc='\033[0m'
write() {
	if var $4 ; then
		echo -e "$1 ${white}~${nc} $2 \e \e \e\ $3 ${white}~${nc} $4"
	elif var $2 ; then
		echo -e "$1 ~ $2"
	else
		echo -e "$1"
	fi
}

