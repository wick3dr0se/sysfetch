#!/bin/bash


# // LOAD AVGS // w tr /proc/loadavg
echo -ne "${YELLOW}avgs${NC} ~ "
awk '{print $1,$2,$3}' < /proc/loadavg
