#!/bin/bash

# // DE/WM // if file exist print 'DesktopNames'
echo -ne "${YELLOW}de/wm${NC} ~ "
if [[ -e /usr/share/xsessions/ ]] ; then
         head /usr/share/xsessions/* | grep -im1 'names=' | sed 's/DesktopNames=//' | tr -d '\n'
elif [[ -e /usr/share/wayland-sessions/ ]] ; then
        head /usr/share/wayland-sessions/* | grep -im1 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
elif [[ $(command -v xprop) ]] ; [[ ! -z $DISPLAY ]] ; then
	id=$(xprop -root | sed -n '/^_NET_SUPPORTING_WM_CHECK/ s/.* // p')
	echo $(xprop -id "$id" | sed -n '/^_NET_WM_NAME/ s/.* // p' | sed 's/"//g') | tr -d "\n"
else
        echo not found
fi



## // THEME // if variable doesn't return 0 then print gtk_name
echo -ne " \e \e \e \e "
echo -ne "${BLUE}theme${NC} ~ "
theme_name=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g" | tr -d '\n')
if [[ -e ~/.config/gtk-3.0/settings.ini ]] ; then
        gtk_name=$(grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | sed 's/gtk-theme-name=//g' | sed 's/-/ /g')
        #Some people may have a settings.ini file in their system, but theme-name may be not there.
        if [[ ! -z "$gtk_name" ]] ; then
		echo "$gtk_name"
	fi
fi
if [[ ! -z "$theme_name" ]] && [[ -z "$gtk_name" ]] ; then
	echo $theme_name
else
	echo not found
fi
