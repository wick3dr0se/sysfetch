#!/bin/bash


# // LOAD AVGS // w shell redirect into awk
echo -ne "${PURPLE}load${NC} ~ "
head /proc/loadavg
