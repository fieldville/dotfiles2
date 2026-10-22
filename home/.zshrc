# zsh interactive shell. Plain zsh + Starship; oh-my-zsh and zplug are retired.
# Kept in step with .bashrc so bash (WSL) and zsh (macOS) behave the same.

# --- history (same sizes and dedup behaviour as .bashrc)
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups hist_ignore_all_dups hist_ignore_space
setopt share_history inc_append_history extended_history

# --- completion. bashcompinit makes `complete` from .alias/.dalias work in zsh.
autoload -Uz compinit bashcompinit
compinit
bashcompinit
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# --- key bindings: Alt-p / Alt-n search history by the typed prefix
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[p" history-beginning-search-backward-end
bindkey "^[n" history-beginning-search-forward-end

export LESS="iSMR"

# Prepend extra bin dirs to PATH.
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:/usr/sbin:$PATH
export PATH=~/.local/bin:$PATH

[ -f ~/.alias ] && . ~/.alias
[ -f ~/.alias.private ] && . ~/.alias.private
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd j)"
[ -f ~/.falias ] && source ~/.falias
[ -f ~/.kalias ] && source ~/.kalias
[ -f ~/.dalias ] && source ~/.dalias

# Optional Homebrew plugins (brew install zsh-autosuggestions zsh-syntax-highlighting).
# Loaded only when present so a fresh machine still starts cleanly.
if [ -n "$HOMEBREW_PREFIX" ]; then
  if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    . "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    bindkey '^ ' autosuggest-accept
  fi
  # syntax-highlighting must be sourced last among plugins.
  [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] &&
    . "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# conda, if installed at the default Anaconda location.
[ -f /opt/anaconda3/etc/profile.d/conda.sh ] && . /opt/anaconda3/etc/profile.d/conda.sh

# Set your favorite editor here.
export VISUAL=nvim
export EDITOR=nvim

# starship prompt (keep LAST). Config lives in this repo, same as .bashrc and the
# PowerShell profile, so no ~/.config/starship.toml symlink is needed.
if command -v starship >/dev/null 2>&1; then
  : "${STARSHIP_CONFIG:=$HOME/.dotfiles2/home/.config/starship.toml}"
  export STARSHIP_CONFIG
  eval "$(starship init zsh)"
fi
