#!/bin/bash


# // TERM // get terminal name w/ pstree
shell=$(echo "$SHELL" | sed 's%.*/%%')
term=$(pstree -sA $$ | head -n1 | sed 's/head//g;s/fetch.sh//g;s/systemd//g;s/init//g;s/bash//g;s/ash//g;s/zsh//g;s/fish//g;s/^-*//;s/+//;s/-*$//')
if [[ ! -z $shell ]] ; then
	echo -ne "${GREEN}term${NC} ~ "
	echo -ne "$term"
fi


# // SHELL // echo '$SHELL' enviornment variable
echo -ne " \e \e \e \e "
echo -ne "${RED}shell${NC} ~ "
echo $shell
