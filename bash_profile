# Add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

#pyenv used for saltfab
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"

source ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

 # Add golang to PATH
export PATH="$PATH:/usr/local/go/bin"

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH=$QLTY_INSTALL/bin:$PATH
