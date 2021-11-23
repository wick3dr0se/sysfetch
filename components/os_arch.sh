#!/bin/bash

# // OS // print 'PRETTY_NAME'
echo -ne "${GREEN}os${NC} ~ "
awk -F '"' '/PRETTY/ {print $2}' /etc/os-release | tr -d '\n'

# // ARCH // get architecture with uname
echo -ne " \e \e \e \e "
echo -ne "${PURPLE}arch${NC} ~ "
uname -m
