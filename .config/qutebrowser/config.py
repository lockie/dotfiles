config.load_autoconfig()

config.set("colors.webpage.preferred_color_scheme", "dark")

config.bind('<Alt-Shift-p>', 'spawn --userscript qute-keepassxc --key GPGKEY', mode='insert')
config.bind('pw', 'spawn --userscript qute-keepassxc --key GPGKEY', mode='normal')

config.bind(',f', 'spawn --userscript openfeeds')

config.bind(',r', 'spawn --userscript readability')

config.bind(',v', 'spawn mpv --force-window=immediate {url}')
config.bind(',V', 'hint links spawn --detach mpv --force-window=immediate {hint-url}')

config.bind(',c', 'spawn --userscript org-capture')

config.bind(',s', 'spawn --userscript search-selected -s')
config.bind(',g', 'spawn --userscript search-selected -g')

config.unbind('.')
en_keys = "qwertyuiop[]asdfghjkl;'zxcvbnm,./"+'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?'
ru_keys = 'йцукенгшщзхъфывапролджэячсмитьбю.'+'ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,'
c.bindings.key_mappings.update(dict(zip(ru_keys, en_keys)))
