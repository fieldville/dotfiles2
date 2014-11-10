# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
export HISTCONTROL=ignoredups:erasedups

# Append to the history file, don't overwrite it.
shopt -s histappend

export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

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

# some more ls aliases
alias ll='ls -ltrh'
alias la='ll -A'
alias l='ls -CF'
alias df='df -Th'
alias gd='git diff'
alias h='history'

# aliases for git
alias gcl='git clone'
alias ga='git add'
alias gall='git add .'
alias gus='git reset HEAD'
alias gm="git merge"
alias g='git'
alias get='git'
alias gst='git status'
alias gs='git status'
alias gss='git status -s'
alias gl='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull && git push'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gpo='git push origin'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -v -m'
alias gci='git commit --interactive'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gexport='git archive --format zip --output'
alias gdel='git branch -D'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"
alias gd='git diff'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.alias ]; then
    . ~/.alias
fi
if [ -f ~/.alias.private ]; then
    . ~/.alias.private
fi

set -o vi
