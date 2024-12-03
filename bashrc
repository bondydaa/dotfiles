# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# big big history
HISTSIZE=100000
HISTFILESIZE=100000

# no duplicate entries
HISTCONTROL=ignoredups:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export EDITOR='vim'

# disable stupid mac zsh prompt
export BASH_SILENCE_DEPRECATION_WARNING=1

# Set default less behavior
# I - ignore case when searching
# R - enable color output when piping
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=no;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

unset color_prompt force_color_prompt

# Load aliases from ~/.aliases file
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Load extra settings
if [ -f ~/.extra ]; then
    . ~/.extra
fi

function parse_git_dirty {
    if ! git ls-files >& /dev/null; then
        echo ""
    else
        [[ $(git diff --shortstat) ]] && echo "*"
    fi
}
function get_branch_color {
    if ! git ls-files >& /dev/null; then
        echo ""
    else
        local dirty=$(parse_git_dirty)
        if [[ $dirty == '*' ]]
        then
            echo "\[\033[31m\]"
        else
            echo "\[\033[32m\]"
        fi
    fi
}

function twolastdirs {
tmp=${PWD%/*/*};
[ ${#tmp} -gt 0 -a "$tmp" != "$PWD" ] && echo ${PWD:${#tmp}+1} || echo $PWD;
}
function color_my_prompt {
    history -a
    local host="\[\033[01;36m\]\h"
    local dircolor="\[\033[1;34m\]"
    local dir="\W"
    local twolastdirs="$(twolastdirs)"
    local branch_color=$(get_branch_color)
    local git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local last_color="\[\033[00m\]"
    local prompt_symbol="$"
    if  [ -z "${VIRTUAL_ENV}" ] ; then
        export PS1="$dircolor$twolastdirs $branch_color$git_branch$prompt_symbol$last_color "
    else
        export PS1="[saltfab]$dircolor$twolastdirs $branch_color$git_branch$prompt_symbol$last_color "
    fi
}
PROMPT_COMMAND=color_my_prompt

# use gpg agent for ssh
# https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#replace-agents
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

source ~/.git-completion.bash

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
