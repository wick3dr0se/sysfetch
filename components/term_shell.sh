#!/bin/bash


# // TERM // get terminal name w/ pstree
init_strip="s/init//g;s/systemd//g"
shell_strip="s/fish//g;s/bash//g;s/zsh//g;s/ash//g"
shell=$(echo "$SHELL" | sed 's%.*/%%')
term=$(pstree -sA $$ 2>/dev/null | head -n1 | sed "s/head//g;s/fetch.sh//g;$init_strip;$shell_strip;s/^-*//;s/+//;s/-*$//")
if [[ ! -z $shell ]] ; then
	echo -ne "${YELLOW}term${NC} ~ "
	echo -ne "$term"
elif [[ ! -z "$TERM" ]] ; then
	echo -ne "${YELLOW}term${NC} ~ "
	echo -ne "$TERM"
else
	echo -ne "not found"
fi

# // SHELL // echo '$SHELL' enviornment variable
if [[ ! -z "$shell" ]] ; then
	echo -ne " \e \e \e \e "
	echo -ne "${RED}shell${NC} ~ "
	echo $shell
fi
