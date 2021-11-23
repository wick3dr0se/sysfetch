#!/bin/bash


# // TERM // get terminal name w/ pstree
shell="$(echo $SHELL | sed 's%.*/%%')"
if [ `command -v pstree` ] ; then
        term="$(pstree -sA $$)"; term="$(echo ${term%---${shell}*})"; term="$(echo ${term##*---})"
else
        echo $TERM
fi

echo -ne "${GREEN}term${NC} ~ "
echo $term | tr -d "\n"


# // SHELL // echo '$SHELL' enviornment variable
echo -ne " \e \e \e \e "
echo -ne "${RED}shell${NC} ~ "
echo $shell
