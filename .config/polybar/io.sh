#!/usr/bin/env sh

LANG=C iostat -md /dev/sda 1 | stdbuf -o0 cut -d \n -f 3 | stdbuf -o0 tr -s '\n\n' '\n' | stdbuf -o0 tr -s ' ' | stdbuf -o0 cut -d ' ' -f 3,4 | stdbuf -o0 sed 's/ / MB\/s %{F#9fafaf}↓%{F-}/'
