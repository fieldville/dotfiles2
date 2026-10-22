# zsh login shell (macOS Terminal/iTerm open login shells). PATH only; everything
# interactive (aliases, history, prompt) lives in .zshrc, mirroring .profile/.bashrc.
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
