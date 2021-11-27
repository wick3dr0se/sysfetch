#!/bin/bash


# // LOAD AVGS // w shell redirect into awk
echo -ne "${YELLOW}load${NC} ~ "
awk '{print $1,$2,$3}' < /proc/loadavg
