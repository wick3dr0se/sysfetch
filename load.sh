// LOAD AVGS // w tr /proc/loadavg
echo -ne "${YELLOW}avgs${NC} ~ "
cat /proc/loadavg | awk '{print $1,$2,$3}'
