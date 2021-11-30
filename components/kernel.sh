#!/bin/bash

case $systype in

  Linux)

    # // KERNEL // w/ uname
    echo -ne "${YELLOW}kernel${NC} ~ "
    uname -r
    ;;

  Darwin)

    # // KERNEL // w/ uname
    darwinkernel=$(uname -s -r)
    echo -ne "${YELLOW}kernel${NC} ~ ${darwinkernel}"
    ;;
    
esac
