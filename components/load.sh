#!/bin/bash


# // LOAD AVGS // w shell redirect into awk
echo -ne "${YELLOW}avgs${NC} ~ "
awk '{print $1,$2,$3}' < /proc/loadavg
