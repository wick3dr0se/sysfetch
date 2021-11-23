#!/bin/bash

# // UPTIME // run 'uptime'
echo -ne "${CYAN}uptime${NC} ~ "
# check for uptime --pretty instead of file; run if found
if [[ $(command -v uptime --pretty )  ]] ; then
        uptime --pretty | sed -e 's/up//;s/^ *//'
else
        UPTIME=$(uptime)
        UPTIME=$(echo -n "$UPTIME" | sed -e 's/^.*up //')
        UPTIME=$(echo "$UPTIME" | sed -e 's/load.*$//')
        UPTIME=${UPTIME%\,*}
        echo "$UPTIME"
fi
