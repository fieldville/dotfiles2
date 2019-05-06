# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# ~/.bashrc: executed by bash(1) for interactive shells.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the msys2 mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
alias df='df -h'
alias du='du -h'
#
# Misc :)
alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
#alias grep='grep --color'                     # show differences in colour
alias grep='grep --color --exclude-dir={.git,.svn} --exclude=\*.html\*'
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
#alias ll='ls -l'                              # long list
alias ll='ls -ltr'                              # long list
#alias la='ls -A'                              # all but . and ..
alias la='ll -A'                              # all but . and ..
alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
export HISTCONTROL=ignoredups:erasedups

# Append to the history file, don't overwrite it.
shopt -s histappend

#export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# History size up
export HISTSIZE=100000
export HISTFILESIZE=100000

# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set your favorite editor here.
VISUAL=vim; export VISUAL
EDITOR=vim; export EDITOR

# Append /usr/local/bin to the path.
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:/usr/sbin:$PATH

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.alias ]; then
    . ~/.alias
fi
if [ -f ~/.alias.private ]; then
    . ~/.alias.private
fi

export LESS="iSMR"
set -o vi
bind 'set horizontal-scroll-mode off'

stty werase undef
bind '"\C-w": unix-filename-rubout'

stty -ixon
umask 022

#[[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]] && tmux


[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh
. /usr/share/autojump/autojump.sh

## for VirtualBox
export PATH=$PATH:'/mnt/c/Program Files/Oracle/VirtualBox'

## for Vagrant
export PATH=$PATH:/mnt/c/HashiCorp/Vagrant/bin
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_DEFAULT_PROVIDER="hyperv"

alias launchchrome="\"/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe\""

## bash completion for aws cli
complete -C "/usr/local/bin/aws_completer" aws

## for git
# プロンプトに各種情報を表示
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=
GIT_PS1_SHOWSTASHSTATE=1
export PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$\[\033[31m\]$(__git_ps1)\[\033[00m\] '

# added by Miniconda3 4.5.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/mnt/c/WSL/home/miniconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/mnt/c/WSL/home/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/mnt/c/WSL/home/miniconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/mnt/c/WSL/home/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

conda activate py37
export PATH=/mnt/c/WSL/home/.local/bin:$PATH

### for virtualenv
#if [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]; then
#    export WORKON_HOME=$HOME/.virtualenvs
#    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
#    export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv
#    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
#fi

## for direnv
eval "$(direnv hook bash)"

