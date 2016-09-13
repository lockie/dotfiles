#!/usr/bin/env sh

cd ~/.mozilla/firefox/*.default
for i in *.sqlite; do
	echo $i
	echo "VACUUM; REINDEX;" | sqlite3 $i
done

