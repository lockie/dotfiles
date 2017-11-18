#!/usr/bin/env sh

# NOTE : relying on ~/.netrc here
curl --retry 3 --connect-timeout 2 -m 3 -fsn https://mail.google.com/mail/feed/atom | xmllint --xpath "string(//*[local-name()='fullcount' and namespace-uri()='http://purl.org/atom/ns#'])" - 2> /dev/null || echo "ERR"
