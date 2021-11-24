#!/bin/bash


# // TERM // get terminal name w/ pstree
shell="$(echo $SHELL | sed 's%.*/%%')"
term="$(pstree -sA $$)"; term="$(echo ${term%%---${shell}*})"; term="$(echo ${term##*---})"
if [[ $(command -v pstree) ]] ; then
  echo -ne "${GREEN}term${NC} ~ " 
  echo $term | tr -d '\n'
else
  echo $TERM
fi


# // SHELL // echo '$SHELL' enviornment variable
echo -ne " \e \e \e \e "
echo -ne "${RED}shell${NC} ~ "
echo $shell
