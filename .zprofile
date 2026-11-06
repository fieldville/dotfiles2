# zsh login shell (macOS Terminal/iTerm and WSL's first shell are login shells).
# PATH only; everything interactive (aliases, history, prompt) lives in .zshrc,
# mirroring .profile and .bashrc.
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Machine-local environment (PATH, exports, tokens), kept outside this repo: the
# login-shell counterpart of ~/.alias.private. Sourced last so it can override anything
# above. .profile sources the same file, so keep it to syntax both bash and zsh accept.
[ -f ~/.profile.private ] && . ~/.profile.private
