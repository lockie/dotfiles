#!/usr/bin/env sh

pidof xfce4-screensaver >/dev/null || {
	xfce4-screensaver&
	sleep 0.1
}
xfce4-screensaver-command --lock
