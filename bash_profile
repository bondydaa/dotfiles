source ~/.bashrc

#Add homebrew to path
export PATH="/opt/homebrew/bin:$PATH"

#rbenv used for mobile development
if command -v rbenv 1>/dev/null 2>&1; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

#more mobile dev things
#ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.
#linking Rubies to Homebrew's OpenSSL 1.1 (which is upgraded)
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

export NVM_DIR="$HOME/.nvm"
# nvm stuffs for intel
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# nvm stuffs for apple silicon
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Go lang things
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

#pyenv used for saltfab
export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

# Define cscope db path
export CSCOPE_DB=/Users/dbondy/Expensidev/cscope.out

#Android SDK things for react native
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home; # Only for old dot mobile, will break new dot

# Use clang instead of gcc
export CC="ccache /usr/bin/clang-18"
export CXX="ccache /usr/bin/clang++-18"

# Set vim env variable based on latest version, if you update VIM you need to change this!
# commenting this out so neovim works for now
#export VIMRUNTIME=/opt/homebrew/Cellar/vim/9.1.0650/share/vim/vim91

# Warp cert trickery
CA_CERT_PATH="/Users/dbondy/Expensidev/Ops-Configs/saltfab/cacert.pem"

if [ -f "$CA_CERT_PATH" ]; then
    export NODE_EXTRA_CA_CERTS="$CA_CERT_PATH"
    export AWS_CA_BUNDLE="$CA_CERT_PATH"
    export SSL_CERT_FILE="$CA_CERT_PATH"
    export CURL_CA_BUNDLE="$CA_CERT_PATH"
    export BUNDLE_SSL_CA_CERT="$CA_CERT_PATH"
    export REQUESTS_CA_BUNDLE="$CA_CERT_PATH"
fi
