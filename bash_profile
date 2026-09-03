# Add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

 # Add golang to PATH
export PATH="$PATH:/usr/local/go/bin"

# Python Stuff
export PATH="/Users/dbondy/.local/bin:$PATH"

# Aider Stuff
export OLLAMA_API_BASE=http://127.0.0.1:11434

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH=$QLTY_INSTALL/bin:$PATH

export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"

export KUBECONFIG=${HOME?}/teleport-kubeconfig.yaml

# Create variable to track version of postgresql, and add it to path
export PSQL_VERSION=15
export PATH="/opt/homebrew/opt/postgresql@${PSQL_VERSION}/bin:$PATH"
export GITHUB_TOKEN="<PAT>"
export DD_API_KEY="<API_KEY>"
export DD_APP_KEY="<APP_KEY>"

# terraform, 2nd one may not be needed but if terraform init commands start failing try it out
export TF_REGISTRY_CLIENT_TIMEOUT=30
#export TF_REGISTRY_DISCOVERY_RETRY=5
