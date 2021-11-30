#!/bin/bash

case $systype in

  Linux)

    # // TERM // get terminal name w/ pstree
    if [[ $(command -v pstree) ]] ; then
          echo -ne "${RED}term${NC} ~ $term \e \e \e \e "
    elif [[ ! -z "$TERM" ]] ; then
          echo -ne "${RED}term${NC} ~ $TERM \e \e \e \e "
    else
          echo -ne "not found"
    fi

    # // SHELL // echo '$SHELL' enviornment variable
    if [[ ! -z "$SHELL" ]] ; then
          echo -e "${BLUE}shell${NC} ~ $shell"
    else
          echo -ne "\n"
    fi
    ;;

  Darwin)

    # // TERM // ger terminal name w/ global variable
    echo -ne "${RED}term${NC} ~ $TERM_PROGRAM"

    # // SHELL // echo '$SHELL' environment variable
    echo -e "${BLUE}shell${NC} ~ $shell"
    ;;

esac
