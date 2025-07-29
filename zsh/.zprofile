if [[ "$(uname -s)" == "Darwin" ]]; then
  # macOS specific settings
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
else
  # Linux specific settings
fi

