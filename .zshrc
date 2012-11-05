
#
# чтобы видеть все процессы для kill или killall
#
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: %l matches, current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit promptinit
compinit -D
promptinit; prompt gentoo

autoload colors && colors

# Вывод информации о репозиториях
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn bzr darcs fossil hg
# Модифицированная версия из man zshcontrib, добавлены флажки staged и unstaged изменений
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}%m%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}][%B%F{yellow}%c%F{red}%u%%b%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}%m%F{5}[%F{2}%b%F{5}][%B%F{yellow}%c%F{red}%u%%b%F{5}]%f '
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' get-revision true
precmd () { vcs_info }

# Lines configured by zsh-newuser-install
export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

###########################################################################

setopt HIST_IGNORE_DUPS
setopt autocd
setopt PROMPT_SUBST

# Исправлять ошибки
setopt correctall
# Что при этом говорит?
SPROMPT="	$fg[red]%R$reset_color → $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "

export PROMPT="%(?,$(print '%{\e[1;32m%}^_^%{\e[0m%}'),$(print '%{\e[1;31m%}>_<%{\e[0m%}')) [$(print '%{\e[1;30m%}%m%{\e[0m%}'):$(print '%{\e[1;36m%}%n%{\e[0m%}@%{\e[1;33m%}%~%{\E[0m%}')]> "
export RPS1="%U[%T %D]%u"
export RPROMPT='${vcs_info_msg_0_}'$RPS1
export HGUSER=$USER
ulimit -c unlimited

# Цветной ls и пара полезных алиасов заодно
if [ "$TERM" != "dumb" ] && [ `which dircolors` ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto --group-directories-first'
    alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='nocorrect grep --color=auto'
    alias fgrep='nocorrect fgrep --color=auto'
    alias egrep='nocorrect egrep --color=auto'
	alias which='nocorrect which'
fi
alias grep='nocorrect grep'
if [ -f /usr/lib/perl5/vendor_perl/bin/ack ] || [ -f /usr/bin/perlbin/vendor/ack ]; then
	alias grep='nocorrect ack'
fi
if [ -f /usr/bin/ack-grep ]; then
	alias grep='nocorrect ack-grep'
fi
if [ -f /usr/bin/ack ]; then
	alias grep='nocorrect ack'
fi

# Раскраска ^___^
if [ -f /usr/bin/grc ]; then
	alias ping="grc --colour=auto ping"
	alias traceroute="grc --colour=auto traceroute"
	alias make="grc --colour=auto make"
	alias diff="grc --colour=auto diff"
	alias cvs="grc --colour=auto cvs"
	alias netstat="grc --colour=auto netstat"
	alias gcc="grc --colour=auto gcc"	
fi

alias cls=clear
alias mv='nocorrect mv'  # чтобы случайно не удалить чего-нибудь
alias rm='nocorrect rm'  # чтобы случайно не удалить чего-нибудь
alias cp='nocorrect cp'  # ... или не скопировать
alias mkdir='nocorrect mkdir'  # ... или не сделать лишний каталог
alias sudo='nocorrect sudo'  # ... или не натворить делов
alias kill='nocorrect kill'
alias killall='nocorrect killall'
if [ -f /usr/bin/pacman ]; then
	alias pacman='nocorrect pacman'
fi
if [ -f /usr/bin/yaourt ]; then
	alias yaourt='nocorrect yaourt'
fi
if [ -f /usr/bin/clyde ]; then
	alias clyde='nocorrect sudo clyde'
	alias upd='clyde -Suy --aur'
fi
if [ -f /usr/bin/aptitude ]; then
	alias upd='sudo aptitude update && sudo aptitude safe-upgrade'
	alias aptitude='nocorrect aptitude'
	alias apt-get='nocorrect apt-get'
fi
if [ -f /usr/bin/mpkg ]; then
	alias mpkg='nocorrect mpkg'
	alias upd='sudo mpkg update && sudo mpkg upgradeall'
fi
if [ -f /usr/bin/emerge ]; then
	alias emerge='nocorrect emerge'
	alias eix='nocorrect eix'
	alias cave='nocorrect cave'
	alias eselect='nocorrect eselect'
	alias equery='nocorrect equery'
	alias upd='sudo eix-sync -C --quiet && sudo emerge --keep-going=y -uDNvat @world && sudo revdep-rebuild'
#	alias upd='sudo emerge -uDNva world'
fi


alias c='cd'
alias psa='ps axu'
alias psf='ps axuf'
alias cmd='ipython'
alias l='ls'
alias ll='ls -alh'
if [ -f /usr/bin/htop ]; then
	alias top='htop'
fi

#alias less='less -M'
#alias less='/usr/share/vim/vim72/macros/less.sh'
#if [ -f /usr/bin/lesspipe.sh ]; then
#	eval $(lesspipe.sh)
#fi
export LESSCHARSET=UTF-8
#export LESS=' -R '

alias du='du -hsx'

if [ -f /usr/bin/pbzip2 ]; then
	alias bzip2='pbzip2 -v -p4'
fi


function gitdiff() {
	git diff --no-ext-diff -w "$@"
}

#
# Установка нормального поведения клавиш Delete, Home, End:
#
case "$TERM" in
	xterm)
 		bindkey "^[OH" beginning-of-line
		bindkey "^[OF" end-of-line
		bindkey "^[[H" beginning-of-line
		bindkey "^[[F" end-of-line
		;;
	rxvt-unicode)
		bindkey "^[[7~" beginning-of-line
		bindkey "^[[8~" end-of-line	
		;;
	*)
		bindkey "^[[1~" beginning-of-line
		bindkey "^[[4~" end-of-line
esac
bindkey "^[[3~" delete-char
bindkey "^[[2~" yank
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# Автодополнение хостов для ssh/scp
#hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}% % *}% %,*})
#zstyle ':completion:*:(ssh|scp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp):*' tag-order '! users'


# Распаковка любого архива (http://muhas.ru/?p=55)
unpack() {
if [ -f $1 ] ; then
case $1 in
	*.tar.bz2)   tar xjf $1        ;;
	*.tar.gz)    tar xzf $1     ;;
	*.bz2)       bunzip2 $1       ;;
	*.rar)       unrar x $1     ;;
	*.gz)        gunzip $1     ;;
	*.tar)       tar xf $1        ;;
	*.tbz2)      tar xjf $1      ;;
	*.tgz)       tar xzf $1       ;;
	*.zip)       unzip $1     ;;
	*.Z)         uncompress $1  ;;
	*.7z)        7z x $1    ;;
	*)           echo "Cannot unpack '$1'..." ;;
esac
else
echo "'$1' is not a valid file"
fi
}
# ... и упаковка (http://muhas.ru/?p=55)
pack() {
if [ $1 ] ; then
case $1 in
	tbz)   	tar cjvf $2.tar.bz2 $2      ;;
	tgz)   	tar czvf $2.tar.gz  $2   	;;
	tar)  	tar cpvf $2.tar  $2       ;;
	bz2)	bzip $2 ;;
	gz)		gzip -c -9 -n $2 > $2.gz ;;
	zip)   	zip -r $2.zip $2   ;;
	7z)    	7z a $2.7z $2    ;;
	*)     	echo "'$1' Cannot be packed via pack()" ;;
esac
else
echo "'$1' is not a valid file"
fi
}

# Привязки файлов к программам
alias -s {avi,mpeg,mpg,mov,m2v,flv}=mplayer
alias -s txt=vi
alias -s {ogg,mp3,wav}=mplayer
alias -s {jpg,jpeg,png,gif}=display

# Печенюшка на дорожку ^_^
if [ -f /usr/bin/fortune ] || [ -f /usr/games/fortune ]; then
	fortune -a
fi

