#!/usr/bin/env bash

cd .mozilla/firefox/*.default
python2 <<< $'import json\nf = open("sessionstore.js", "r")\njdata = json.loads(f.read())\nf.close()\nfor win in jdata.get("windows"):\n\tfor tab in win.get("tabs"):\n\t\ti = tab.get("index") - 1\n\t\tprint tab.get("entries")[i].get("url")'

