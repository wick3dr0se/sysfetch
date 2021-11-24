#!/bin/bash

# // DE/WM // if file exist print 'DesktopNames'
echo -ne "${YELLOW}de/wm${NC} ~ "
if [[ -e /usr/share/xsessions/ ]] ; then
         head /usr/share/xsessions/* | grep -im1 'names=' | sed 's/DesktopNames=//;s/CLASSIC//;s/Ubuntu//;s/ubuntu//;s/Classic//;s/GNOME//2g' | tr -d '\n'
elif [[ -e /usr/share/wayland-sessions/ ]] ; then
        head /usr/share/wayland-sessions/* | grep -im1 'name=' | sed 's/name=//gi' | sort -u | sed ':a;N;$!ba;s/\n/, /gi' | tr -d '\n'
elif [[ $(command -v xprop) ]] ; [[ ! -z $DISPLAY ]] ; then
        xprop -root | grep -m1 '^_NET_WM_NAME' | sed 's/^_NET_WM_NAME//g;s/(UTF8_STRING) = //g' | tr -d '"\n'
else
        echo not found
fi


# // THEME // get theme name from settings.ini if variable exist, if not found print output to /dev/null. stat gsettings if variable found 
echo -ne " \e \e \e \e "
echo -ne "${BLUE}theme${NC} ~ "
gtk_name=$(grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini 2>/dev/null | sed 's/gtk-theme-name=//g' | sed 's/-/ /g')
theme_name=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g" | tr -d '\n')
if [[ ! -z "$gtk_name" ]] ; then
  echo "$gtk_name"
elif [[ ! -z "theme_name" ]] ; then
  echo "$theme_name"
else
  echo "not found"
fi





