export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$HOME/bin:$HOME/bin/Telegram:$HOME/.cabal/bin:$PATH"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BG1=none

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
