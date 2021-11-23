#!/bin/bash


# Get raw seconds value
raw_sec=$(head /proc/uptime | awk '{print $1}')
raw_sec=${raw_sec%\.*}
# da math
printf '%d weeks, %d hours, %d minutes \n' $(($raw_sec/604800)) $(($raw_sec/3600)) $(($raw_sec%3600/60))
