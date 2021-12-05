#!/bin/bash

# // DE/WM //
if [[ "$os" = "Darwin" ]] ; then
	echo -ne "${RED}de/wm${NC} ~ Aqua "
elif [[ ! -z "$XDG_CURRENT_DESKTOP" ]] ; then
	echo -ne "${RED}de/wm${NC} ~ $session \e \e \e \e "
elif [[ -e /usr/share/xsessions/ ]] ; then
	echo -ne "${RED}de/wm${NC} ~ "
	head /usr/share/xsessions/* | grep -im1 'names=' | sed 's/DesktopNames=//;s/CLASSIC//g;s/Ubuntu//;s/ubuntu//g;s/Classic//g;s/GNOME//2g' | tr -d ':-;\n'
	echo -ne " \e \e \e \e "
elif [[ -e /usr/share/wayland-sessions/ ]] ; then
	echo -ne "${RED}de/wm${NC} ~ "
	head /usr/share/wayland-sessions/* | grep -im1 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
	echo -ne " \e \e \e \e "
elif [[ $(command -v xprop) ]] && [[ ! -z $DISPLAY ]] ; then
	echo -ne "${RED}de/wm${NC} ~ "
	echo $(xprop -id "$id" | sed -n '/^_NET_WM_NAME/ s/.* // p' | sed 's/"//g') | tr -d "\n"
	echo -ne " \e \e \e \e "
else
	echo -ne "${RED}de/wm${NC} ~ "
	echo -ne "not found \e \e \e \e "
fi


# // THEME //
if [[ "$os" = "Darwin" ]] ; then
	echo -e "${YELLOW}theme${NC} ~ $darwin_simple_name"
elif [[ -e ~/.config/gtk-3.0/settings.ini ]] ; then
	echo -e "${YELLOW}theme${NC} ~ $gtk_name"
elif [[ $(command -v gsettings) ]] && [[ ! -z "$theme_name" ]] ; then
	echo -e "${YELLOW}theme${NC} ~ $theme_name"
else
	echo -ne "\n"
fi
