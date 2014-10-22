#!/usr/bin/env bash
# {{{
# vim: foldmethod=marker
# vim: foldcolumn=4
# }}}

# bash-it {{{
# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
#export BASH_IT_THEME='powerline'
export BASH_IT_THEME='bakke'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Set my editor and git editor
export EDITOR="/usr/bin/vim"
export GIT_EDITOR='/usr/bin/vim'

# Set the path nginx
export NGINX_PATH='/opt/nginx'

# Don't check mail when opening terminal.
unset MAILCHECK


# Change this to your console based IRC client of choice.

#export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli

export TODO="t"

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

#}}}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# Load Bash It
if [ -r $BASH_IT ]; then
    source $BASH_IT/bash_it.sh
fi

if [ -r $HOME/.homesick ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
fi

# 256-color mode not supported on this host
if ! infocmp screen-256color >/dev/null 2>&1 && echo $TERM | grep -q -- '-256color'; then
    echo -e '\n\n256-color mode not supported on this host.  Reverting TERM...\n'
    export TERM=`echo -n $TERM | sed 's/-256color//'`
else
    # Colorize the prompt.
    yellow=$(tput setaf 3)
    green=$(tput setaf 2)
    blue=$(tput setaf 104)
    bold=$(tput bold)
    reset=$(tput sgr0)

    PS1="\[$yellow\]\u\[$reset\]@\[$green\]\h\[$reset\]:\[$blue$bold\]\w\[$reset\]$ "

    # Enable color support of ls and also add handy aliases.
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
