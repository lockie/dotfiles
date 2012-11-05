#!/usr/bin/env sh

nitrogen --restore
xsetroot -cursor_name left_ptr
setxkbmap -layout us,ru -option "grp:ctrl_shift_toggle,grp_led:scroll" -variant ",winkeys"
xscreensaver -nosplash &
volti &
/opt/dropbox/dropbox &
exec /usr/bin/awesome
