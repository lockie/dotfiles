export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH:$HOME/.local/bin:$HOME/bin:$HOME/bin/Telegram:$HOME/.cabal/bin"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
if [ "$TERM" != "linux" ]; then
	export TERM=xterm-256color
fi
export BG1=none

eval "$(pyenv init -)"
