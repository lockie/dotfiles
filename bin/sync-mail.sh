#!/usr/bin/env sh
# NOTE: this is to be called from user's crontab

set -e

mbsync -aq
MUHOME="$HOME/.cache/mu" mu index -q
