#! /bin/bash
# lxsession &
picom --experimental-backends &
nitrogen --restore &
urxvtd -q -o -f &
# /usr/bin/emacs --daemon &
volumeicon &
nm-applet &
flatpak run com.toggl.TogglDesktop &
/usr/bin/dunst &
teams &
./Downloads/pcloud_appimage &
