#!/bin/bash

case $systype in

  Linux)

    #// USERNAME/HOST //
    [[ $(command -v uname) ]] ; echo -e "${PURPLE}$host${NC}@${BLUE}$user${NC}"
    ;;

  Darwin)
    #// USERNAME/HOST //
    [[ $(command -v uname) ]] ; echo -e "${PURPLE}$host${NC}@${BLUE}$user${NC}"
    ;;

esac
