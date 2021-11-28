#!/bin/bash


# // TERM // get terminal name w/ pstree
if [[ ! -z $shell ]] ; then
	echo -ne "${RED}term${NC} ~ "
	echo -ne "$term"
elif [[ ! -z "$TERM" ]] ; then
	echo -ne "${YELLOW}term${NC} ~ "
	echo -ne "$TERM"
else
	echo -ne "not found"
fi

# // SHELL // echo '$SHELL' enviornment variable
if [[ ! -z "$shell" ]] ; then
	echo -ne " \e \e \e \e ${BLUE}shell${NC} ~ "
	echo -e "$shell"
fi
