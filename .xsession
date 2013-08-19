#!/usr/bin/env sh

nitrogen --restore &
xsetroot -cursor_name left_ptr &
setxkbmap -layout us,ru -option "grp:ctrl_shift_toggle,grp_led:scroll,terminate:ctrl_alt_bksp" -variant ",winkeys" &
xset r rate 180 35 &
xscreensaver -nosplash &
volti &
/opt/dropbox/dropbox &
exec /usr/bin/awesome
