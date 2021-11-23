#!/bin/bash

# // DE/WM // if file exist print 'DesktopNames'
echo -ne "${YELLOW}de/wm${NC} ~ "
if test -e /usr/share/xsessions/  ; then
         cat /usr/share/xsessions/* | grep -i 'names=' | sed 's/DesktopNames=//' | tr -d '\n'
elif test -e /usr/share/wayland-sessions/* ; then
        cat /usr/share/wayland-sessions/* | grep -i 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
elif [[ $(command -v xprop) ]] ; then
        xprop -root | grep '^_NET_WM_NAME' | sed 's/^_NET_WM_NAME//g;s/(UTF8_STRING) = //g' | tr -d '\n'
else
        echo not found
fi


# // THEME // if file exist print 'gtk-theme-name'
echo -ne " \e \e \e \e "
echo -ne "${BLUE}theme${NC} ~ "
if test -e ~/.config/gtk-3.0/settings.ini ; then
        grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | sed 's/gtk-theme-name=//g' | sed 's/-/ /g'
elif [[ $(command -v gsettings) ]] ; then
        echo $(gsettings get org.gnome.desktop.interface gtk-theme | tr -d '\n')
else
        echo not found
fi
