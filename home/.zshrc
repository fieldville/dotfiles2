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

# --- key bindings. Same as bash (.inputrc): emacs keymap, history search by
# the typed prefix on Ctrl-p/Ctrl-n, Alt-p/Alt-n and Up/Down.
# "bindkey -e" is explicit because zsh would otherwise pick the vi keymap
# whenever EDITOR/VISUAL=nvim is inherited from the environment (e.g. inside byobu).
bindkey -e
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
for k in "^P" "^[p" "^[[A" "^[OA"; do
  bindkey "$k" history-beginning-search-backward-end
done
for k in "^N" "^[n" "^[[B" "^[OB"; do
  bindkey "$k" history-beginning-search-forward-end
done
# Alt-k / Alt-j cycle completions forward / backward (menu-complete in .inputrc)
bindkey "^[k" menu-complete
bindkey "^[j" reverse-menu-complete
# completion-ignore-case
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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
[ -f ~/.fieldville/nvim/docker/alias.sh ] && . ~/.fieldville/nvim/docker/alias.sh

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

# --- added on Ubuntu 26.04 migration (same as .bashrc)
[ -f ~/.cargo/env ] && . ~/.cargo/env
export PATH="$HOME/.local/share/fnm:$PATH"
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
