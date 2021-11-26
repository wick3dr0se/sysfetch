#!/bin/bash

# // DE/WM // if file exist print 'DesktopNames'
session=$(echo $XDG_CURRENT_DESKTOP)
dewm="${YELLOW}de/wm${NC} ~ "
if [[ ! -z "$session" ]] ; then
	echo -ne "$dewm"
	echo -ne "$session"
elif [[ -e /usr/share/xsessions/ ]] ; then
        echo -ne "$dewm"
	head /usr/share/xsessions/* | grep -im1 'names=' | sed 's/DesktopNames=//;s/CLASSIC//;s/Ubuntu//;s/ubuntu//;s/Classic//;s/GNOME//2g' | tr -d ':-;\n'
elif [[ -e /usr/share/wayland-sessions/ ]] ; then
        echo -ne "$dewm"
	head /usr/share/wayland-sessions/* | grep -im1 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
elif [[ $(command -v xprop) ]] && [[ ! -z $DISPLAY ]] ; then
	id=$(xprop -root 2>/dev/null | sed -n '/^_NET_SUPPORTING_WM_CHECK/ s/.* // p')
	echo -ne "$dewm"
	echo $(xprop -id "$id" | sed -n '/^_NET_WM_NAME/ s/.* // p' | sed 's/"//g') | tr -d "\n"
else
	echo -ne "$dewm"
	echo -ne "not found"
fi


# // THEME // get theme name from settings.ini if variable exist, if not found print output to /dev/null. stat gsettings if variable found 
echo -ne " \e \e \e \e "
echo -ne "${BLUE}theme${NC} ~ "
gtk_name=$(grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini 2>/dev/null | sed 's/gtk-theme-name=//g' | sed 's/-/ /g')
theme_name=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | sed "s/'//g" | tr -d '\n')
if [[ ! -z "$gtk_name" ]] ; then
	echo "$gtk_name"
elif [[ $(command -v gsettings) ]] && [[ ! -z "theme_name" ]] ; then
	echo "$theme_name"
fi





