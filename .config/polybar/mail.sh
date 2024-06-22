#!/usr/bin/env sh

MUHOME="$HOME/.cache/mu" mu find flag:unread AND '(maildir:/awkravchuk/inbox OR maildir:/lockie666/inbox)' --fields=m 2>/dev/null | wc -l
