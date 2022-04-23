export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$HOME/bin:$HOME/.cabal/bin:$HOME/.npm/bin:$HOME/.local/share/go/bin:$PATH"
export GOPATH="$HOME/.local/share/go"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BG1=none

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(luarocks path --bin)"
