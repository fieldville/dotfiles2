# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
export HISTCONTROL=ignoredups:erasedups

# Append to the history file, don't overwrite it.
shopt -s histappend

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

export LESS="iSMR"
bind 'set horizontal-scroll-mode off'

# Append /usr/local/bin to the path.
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:/usr/sbin:$PATH
export PATH=~/.local/bin:$PATH

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.alias ] && . ~/.alias
[ -f ~/.alias.private ] && . ~/.alias.private
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.falias ] && source ~/.falias
[ -f ~/.kalias ] && source ~/.kalias
[ -f ~/.dalias ] && source ~/.dalias
[ -f ~/.lazyvim/.alias ] && . ~/.lazyvim/.alias

[ -r ~/.byobu/prompt ] && . ~/.byobu/prompt #byobu-prompt#
