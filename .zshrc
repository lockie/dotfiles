
unset TERMINFO  # emacs shell compatibility

#
# чтобы видеть все процессы для kill или killall
#
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'

# add custom completion scripts
fpath=(~/.zsh/completion $fpath)

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: %l matches, current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matches for: %d%b'
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit promptinit
compinit -D
promptinit

if [ -f /etc/lsb-release ]; then
	source /etc/lsb-release
else
	DISTRIB_ID="Unknown"
fi

if [ "$DISTRIB_ID" = "Gentoo" ]; then
	prompt gentoo
fi


autoload colors && colors

# Вывод информации о репозиториях
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn bzr darcs fossil hg
# Модифицированная версия из man zshcontrib, добавлены флажки staged и unstaged изменений
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}%m%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}][%B%F{yellow}%c%F{red}%u%%b%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}%m%F{5}[%F{2}%b%F{5}][%B%F{yellow}%c%F{red}%u%%b%F{5}]%f '
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
# XXX если тормозит при rebase, то в файле /usr/share/zsh/5.2/functions/VCS_Info/Backends/VCS_INFO_get_data_git нужно поменять "grep" на "/bin/grep"
precmd () { vcs_info; }

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Acr words
  read -cnr cword
  export reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 "$words[1]" ) )
}
compctl -K _pip_completion pip
# pip zsh completion end

# Lines configured by zsh-newuser-install
export HISTFILE=~/.histfile
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt appendhistory beep extendedglob nomatch notify noequals
# End of lines configured by zsh-newuser-install

###########################################################################

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt autocd
setopt PROMPT_SUBST
setopt INTERACTIVE_COMMENTS

setopt autopushd
alias pp=popd

export LISTMAX=0

#
# vim-режим
#
bindkey -v


export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtenv_indicator {
	if [[ -z $VIRTUAL_ENV ]]; then
		psvar[1]=''
	else
		psvar[1]=${VIRTUAL_ENV##*/}
	fi
}

add-zsh-hook precmd virtenv_indicator

function zle-line-init zle-keymap-select {
	RPS1="%U[%T]%u"
	RPROMPT='${vcs_info_msg_0_}'$RPS1
	RPS2=$RPS1
	if [[ $TERM = "linux" ]] || [[ $TERM = "eterm-color" ]] then
		export PROMPT="%(?,$(print '%{\e[1;32m%}^_^%{\e[0m%}'),$(print '%{\e[1;31m%}>_<%{\e[0m%}')) %(1V.$(print ' %{$fg_bold[blue]%}(%1v%)%{$reset_color%}').) ${${KEYMAP/vicmd/$(print '%{$fg_bold[white]%}N%{$reset_color%}')}/(main|viins)/$(print '%{$fg_no_bold[gray]%}I%{$reset_color%}')}[$(print '%{\e[1;2m%}%m%{\e[0m%}'):$(print '%{\e[1;36m%}%n%{\e[0m%}@%{\e[1;33m%}%~%{\E[0m%}')]> "
	else
		export PROMPT="%(?,$(print '%{\e[1;32m%}%G%1{\xf0\x9f\x98\x84%} %{\e[0m%}'),$(print '%{\e[1;31m%}%G%1{\xf0\x9f\x98\xa3%} %{\e[0m%}'))%(1V.$(print ' %{$fg_bold[blue]%}(%1v%)%{$reset_color%}').) ${${KEYMAP/vicmd/$(print '%{$fg_bold[white]%}N%{$reset_color%}')}/(main|viins)/$(print '%{$fg_no_bold[gray]%}I%{$reset_color%}')}[$(print '%{\e[1;2m%}%m%{\e[0m%}'):$(print '%{\e[1;36m%}%n%{\e[0m%}@%{\e[1;33m%}%~%{\E[0m%}')]> "
	fi
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Исправлять ошибки
setopt correctall
# Что при этом говорит?
export SPROMPT="	$fg[red]%R$reset_color → $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "

export HGUSER=$USER
ulimit -c unlimited

# Раскраска ^___^
source "$HOME/.zsh/warhol.plugin.zsh/warhol.plugin.zsh"

alias grep='nocorrect grep'

# Цветной ls и пара полезных алиасов заодно
if [ "$TERM" != "dumb" ] && hash dircolors 2>/dev/null; then
	eval "$(dircolors -b)"
	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

	alias ls='ls --color=auto --group-directories-first'
	alias dir='ls --color=auto --format=vertical'
	alias grep='nocorrect grep --color=auto'
	alias fgrep='nocorrect fgrep --color=auto'
	alias egrep='nocorrect egrep --color=auto'
	alias which='nocorrect which'
fi
hash ack        2>/dev/null && { alias grep='nocorrect ack';              }
hash ack-grep   2>/dev/null && { alias grep='nocorrect ack-grep';         }
hash ag         2>/dev/null && { alias grep='nocorrect ag';               }
hash bfs        2>/dev/null && { alias find='nocorrect bfs';              }
hash curl       2>/dev/null && { alias curl='nocorrect curl';             }
hash virtualenv 2>/dev/null && { alias virtualenv='nocorrect virtualenv'; }
hash mpv        2>/dev/null && { alias mplayer='mpv';                     }

if [ -f ~/.bash_aliases ]; then
 . ~/.bash_aliases
fi

alias mv='nocorrect mv'  # чтобы случайно не удалить чего-нибудь
alias rm='nocorrect rm'  # чтобы случайно не удалить чего-нибудь
alias ln='nocorrect ln'
alias make='nocorrect make'
alias cp='nocorrect cp'  # ... или не скопировать
alias mkdir='nocorrect mkdir'  # ... или не сделать лишний каталог
alias sudo='nocorrect sudo'  # ... или не натворить делов
alias kill='nocorrect kill'
alias killall='nocorrect killall'
alias pkill='nocorrect pkill'
alias howdoi='nocorrect howdoi'
alias xlaunch='nocorrect xlaunch'
hash pacman 2>/dev/null && {
	alias pacman='nocorrect pacman'
}
hash yaourt 2>/dev/null && {
	alias yaourt='nocorrect yaourt'
}
hash clyde 2>/dev/null && {
	alias clyde='nocorrect sudo clyde'
	alias upd='clyde -Suy --aur'
}
hash aptitude 2>/dev/null && {
	alias upd='sudo aptitude update && sudo aptitude safe-upgrade && sudo apt-get autoremove  && sudo aptitude clean'
	alias aptitude='nocorrect aptitude'
	alias apt-get='nocorrect apt-get'
}
hash mpkg 2>/dev/null && {
	alias mpkg='nocorrect mpkg'
	alias upd='sudo mpkg update && sudo mpkg upgradeall'
}
hash emerge 2>/dev/null && {
	alias emerge='nocorrect emerge'
	alias eix='nocorrect eix'
	alias cave='nocorrect cave'
	alias eselect='nocorrect eselect'
	alias equery='nocorrect equery'
	alias upd='sudo eix-sync -C --quiet && sudo emerge --keep-going=y --with-bdeps=y --backtrack=1000 --verbose-conflicts -uDNvat @world ; sudo emerge -vat --keep-going=y @preserved-rebuild ; sudo smart-live-rebuild -- -vat --keep-going=y ; sudo emerge --depclean --with-bdeps=y -a ; sudo revdep-rebuild -i -- -vat ; sudo env-update'
	alias updk='sudo sh -c "cd /usr/src/linux && zcat /proc/config.gz > .config && make oldconfig && make -j5 && cp -v arch/x86_64/boot/bzImage /boot/efi/boot/bootx64.efi"'
	alias updm='sudo mkdir -p /lib/modules/`uname -r` && sudo ln -sf /usr/src/linux-`uname -r` /lib/modules/`uname -r`/source && sudo ln -sf /usr/src/linux-`uname -r` /lib/modules/`uname -r`/build && sudo emerge -1vta --keep-going=y @module-rebuild'
}
hash avconv 2>/dev/null && {
	command -v ffmpeg >/dev/null 2>&1 || alias ffmpeg='avconv'
}
alias git='nocorrect git'


export LESS="$LESS -j2 -i -W"
export LESSCHARSET=UTF-8

function gitdiff {
	git diff --no-ext-diff -w "$@"
}

#
# Установка нормального поведения клавиш Delete, Home, End:
#
case "$TERM" in
	xterm|xterm-256color)
		bindkey -M viins "^[OH" beginning-of-line
		bindkey -M vicmd "^[OH" vi-beginning-of-line
		bindkey -M viins "^[OF" end-of-line
		bindkey -M vicmd "^[OF" vi-end-of-line
		bindkey -M viins "^[[H" beginning-of-line
		bindkey -M vicmd "^[[H" vi-beginning-of-line
		bindkey -M viins "^[[F" end-of-line
		bindkey -M vicmd "^[[F" vi-end-of-line
		;;
	rxvt-unicode)
		bindkey -M viins "^[[7~" beginning-of-line
		bindkey -M vicmd "^[[7~" vi-beginning-of-line
		bindkey -M viins "^[[8~" end-of-line
		bindkey -M vicmd "^[[8~" vi-end-of-line
		;;
	st-256color)
		bindkey -M viins "^[[H" beginning-of-line
		bindkey -M vicmd "^[[H" vi-beginning-of-line
		bindkey -M viins "^[[4h~" yank
		bindkey -M vicmd "^[[4h~" vi-insert
		bindkey -M viins "^[[P" delete-char
		bindkey -M vicmd "^[[P" delete-char
		;;
	*)
		bindkey -M viins "^[[1~" beginning-of-line
		bindkey -M vicmd "^[[1~" vi-beginning-of-line
		bindkey -M viins "^[[2~" yank
		bindkey -M vicmd "^[[2~" vi-insert
		bindkey -M viins "^[[3~" delete-char
		bindkey -M vicmd "^[[3~" delete-char
		bindkey "^?" backward-delete-char
esac
bindkey -M viins "^[p" up-line-or-history
bindkey -M vicmd "^[p" up-line-or-history
bindkey -M viins "^[n" down-line-or-history
bindkey -M vicmd "^[n" down-line-or-history
bindkey -M viins "^[[4~" end-of-line
bindkey -M vicmd "^[[4~" vi-end-of-line
bindkey -M viins "^[[5~" up-line-or-history
bindkey -M vicmd "^[[5~" up-line-or-history
bindkey -M viins "^[[6~" down-line-or-history
bindkey -M vicmd "^[[6~" down-line-or-history
bindkey "^?" backward-delete-char

# Автодополнение хостов для ssh/scp
zstyle ':completion:*:(ssh|scp):*' tag-order '! users'

# Распаковка любого архива (http://muhas.ru/?p=55)
unpack() {
if [ -f "$1" ] ; then
case $1 in
	*.tar.bz2)   tar xjf "$1"        ;;
	*.tar.gz)    tar xzf "$1"     ;;
	*.bz2)       bunzip2 "$1"       ;;
	*.rar)       unrar x "$1"     ;;
	*.gz)        gunzip "$1"     ;;
	*.xz)        tar xJf "$1"    ;;
	*.tar)       tar xf "$1"        ;;
	*.tbz2)      tar xjf "$1"      ;;
	*.tgz)       tar xzf "$1"       ;;
	*.zip)       unzip "$1"     ;;
	*.Z)         uncompress "$1"  ;;
	*.7z)        7z x "$1"    ;;
	*)           echo "Cannot unpack '$1'..." ;;
esac
else
echo "'$1' is not a valid file"
fi
}
# ... и упаковка (http://muhas.ru/?p=55)
pack() {
if [ "$1" ] ; then
case $1 in
	tbz)   	tar cjvf "$2.tar.bz2" "$2"      ;;
	tgz)   	tar czvf "$2.tar.gz"  "$2"   	;;
	tar)  	tar cpvf "$2.tar"  "$2"       ;;
	bz2)	bzip2 "$2" ;;
	gz)		gzip -c -9 -n "$2" > "$2.gz" ;;
	zip)   	zip -r "$2.zip" "$2"   ;;
	7z)    	7z a "$2.7z" "$2"    ;;
	*)     	echo "'$1' Cannot be packed via pack()" ;;
esac
else
echo "'$1' is not a valid file"
fi
}

# Привязки файлов к программам
alias -s {avi,mpeg,mpg,mov,m2v,flv}=mplayer
alias -s {md,txt,cpp,cxx,h,hpp,hxx}=gvim
alias -s {ogg,mp3,wav}=mplayer
alias -s {jpg,jpeg,png,gif}=display


# подсветка
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# поиск по истории!
source "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^R' history-substring-search-up
bindkey '^S' history-substring-search-down

# поддержка 256-цветного терминала (чтобы mc не ругался)
source "$HOME/.zsh/zsh-256color/zsh-256color.plugin.zsh"

# уведомления о долгоиграющих командах
source "$HOME/.zsh/zsh-background-notify/bgnotify.plugin.zsh"

# шаблоны gitignore
source "$HOME/.zsh/gibo/gibo-completion.zsh"
export PATH="$HOME/.zsh/gibo:$PATH"
alias gi=gibo

# alias для transfer.sh
source "$HOME/.zsh/transfer.sh"
