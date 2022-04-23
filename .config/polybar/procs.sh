#!/usr/bin/env sh

procs=$(ps --ppid 2 -p 2 --deselect --sort -%cpu --no-headers -o state,comm | fgrep -v ps)
running=$(echo "$procs" | grep "^R" -c)
all=$(echo "$procs" | wc -l)
most=$(echo "$procs" | head -n1 | cut -d ' ' -f 2)
printf "%-32s" "$all %{F#9fafaf}/%{F-} $running $most"
