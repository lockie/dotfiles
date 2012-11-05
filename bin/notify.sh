#!/bin/sh
# notify.sh
# (c) init_6

user=lock
title=$1
text=$2
timeout=$3
urgency=$4
icon=$5
category=$6

if [ -z "$urgency" ]; then
	#low, normal, critical
	urgency=normal
fi
if [ -z "$timeout" ]; then
	timeout=60000
fi
if [ -z "$icon" ]; then
	icon=/usr/share/icons/gnome/scalable/status/dialog-information.svg
	#dialog-error.svg dialog-warning.svg
fi
if [ -z "$category" ]; then
	category=transfer
fi
if [ -z "$title" ]; then
	echo You need to give me a title >&2
	exit 1
fi
if [ -z "$text" ]; then
	text=$title
fi

su $user -c "notify-send -u $urgency -t $timeout -i $icon -c $category '$title' '$text' "
