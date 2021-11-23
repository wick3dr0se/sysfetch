#!/bin/bash

# // HOST@USER // w/ uname & whoami
host=$(uname -n)
user=$(echo $USER)
echo -ne "\e[3m${PURPLE}$user${NC}\e[0m"
echo -e "\e[3m@${YELLOW}$host${NC}\e[0m"
