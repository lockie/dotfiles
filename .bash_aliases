alias cls=clear
alias c='cd'
alias m='mc'
alias v='vim'
function e() {
	pidof emacs && emacsclient -nq -e "(find-file-other-window \"$1\")" || emacsclient -nqc -a "" "$1"
}
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
alias vg='valgrind --leak-check=full --show-leak-kinds=all -- '
hash htop 2>/dev/null && {
	alias top='htop'
}
hash pbzip2 2>/dev/null && {
	alias bzip2='pbzip2 -v -p4'
}
