# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
export HISTCONTROL=ignoredups:erasedups

# Append to the history file, don't overwrite it.
shopt -s histappend

#export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
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
#set -o vi
bind 'set horizontal-scroll-mode off'

# disable because error occured when start GUI
#stty werase undef
bind '"\C-w": unix-filename-rubout'

#[[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]] && tmux

. /usr/share/autojump/autojump.sh

# Append /usr/local/bin to the path.
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:/usr/sbin:$PATH
export PATH=~/.local/bin:$PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.falias ] && source ~/.falias
[ -f ~/.kalias ] && source ~/.kalias
[ -f ~/.dalias ] && source ~/.dalias

[ -r ~/.byobu/prompt ] && . ~/.byobu/prompt #byobu-prompt#
