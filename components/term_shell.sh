#!/bin/bash

# // TERM // get terminal name w/ pstree
if [[ "$os" = "Darwin" ]] ; then
	echo -ne "${YELLOW}term${NC} ~ $TERM_PROGRAM "
elif [[ $(command -v pstree) ]] ; then
	echo -ne "${YELLOW}term${NC} ~ $term \e \e \e \e "
elif [[ ! -z "$TERM" ]] ; then
	echo -ne "${YELLOW}term${NC} ~ $TERM \e \e \e \e "
else
	echo -ne "not found"
fi


# // SHELL // echo '$SHELL' enviornment variable
if [[ ! -z "$SHELL" ]] ; then
	echo -e "${BLUE}shell${NC} ~ $shell"
else
	echo -ne "\n"
fi
