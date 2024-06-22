alias cls=clear
alias c='cd'
alias c-='cd -'
alias m='mc'
alias v='vim'
alias ee='emacs -nw'
alias psa='ps axu'
alias psf='ps axuf'
alias cmd='ipython3'
alias l='ls'
alias ll='ls -alhF'
alias l1='ls -1'
alias du='du -hsx'
alias g='git'
alias gitg='git gui'
alias gg='git gui'
alias gk='gitk --all'
alias dc='docker-compose'
alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --num-callers=30 -- '
alias vgo='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --num-callers=30 --log-file=vg.out -- '
alias w1="watch -n1 "
hash htop 2>/dev/null && {
	alias top='htop'
}
hash pbzip2 2>/dev/null && {
	alias bzip2='pbzip2 -v -p4'
}
hash steam 2>/dev/null && {
	# fucking piece of electron shit
	alias steam='steam -no-cef-sandbox'
}

if [ -f /usr/bin/grc ]; then
	alias ping="grc --colour=auto ping"
	alias traceroute="grc --colour=auto traceroute"
	alias gcc="grc --colour=auto gcc"
	alias make="grc --colour=auto make"
	alias netstat="grc --colour=auto netstat"
	alias stat="grc --colour=auto stat"
	alias diff="grc --colour=auto diff"
	alias wdiff="grc --colour=auto wdiff"
	alias last="grc --colour=auto last"
	alias who="grc --colour=auto who"
	alias mount="grc --colour=auto mount"
	alias ps="grc --colour=auto ps"
	alias dig="grc --colour=auto dig"
	alias ifconfig="grc --colour=auto ifconfig"
	alias df="grc --colour=auto df"
	alias du="grc --colour=auto du -hsx"
	alias ip="grc --colour=auto ip"
	alias env="grc --colour=auto env"
	alias lspci="grc --colour=auto lspci"
	alias lsof="grc --colour=auto lsof"
	alias lsblk="grc --colour=auto lsblk"
	alias id="grc --colour=auto id"
	alias iostat="grc --colour=auto iostat"
	alias free="grc --colour=auto free"
	alias docker="grc --colour=auto docker"
	alias lsmod="grc --colour=auto lsmod"
	alias lsattr="grc --colour=auto lsattr"
	#alias ulimit="grc --colour=auto ulimit"
	alias nmap="grc --colour=auto nmap"
	alias uptime="grc --colour=auto uptime"
	alias whois="grc --colour=auto whois"
fi
