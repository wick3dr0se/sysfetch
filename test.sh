#!/bin/bash
if [[ $(command -v xprop) ]] ; [[ ! -z $DISPLAY ]] ; then
	id=$(xprop -root | sed -n '/^_NET_SUPPORTING_WM_CHECK/ s/.* // p')
	echo $(xprop -id "$id" | sed -n '/^_NET_WM_NAME/ s/.* // p' | sed 's/"//g') | tr -d "\n"
fi
