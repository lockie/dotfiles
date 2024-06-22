export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$HOME/bin:$HOME/.cabal/bin:$HOME/.npm/bin:$HOME/.local/share/go/bin:$PATH"
export MUHOME="$HOME/.cache/mu"
export GOPATH="$HOME/.local/share/go"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GTK_THEME="Adwaita-dark"
export BG1=none
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring  # https://stackoverflow.com/a/75098703/1336774

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(luarocks path --bin)"

eval "$(direnv hook zsh)"
