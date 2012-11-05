#!/usr/bin/env python2
import httplib2
(req,cont) = httplib2.Http().request('http://lib.homelinux.org')
wa = req['www-authenticate']
print wa.split('=')[1].decode('cp1251')
