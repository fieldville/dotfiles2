export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Machine-local environment (PATH, exports, tokens), kept outside this repo: the
# login-shell counterpart of ~/.alias.private. Sourced after the PATH setup above so it
# can override it, and before .bashrc so the interactive setup sees it. .zprofile sources
# the same file, so keep it to syntax both bash and zsh accept.
[ -f ~/.profile.private ] && . ~/.profile.private

# For interactive login shells, defer the rest (aliases, history, prompt,
# starship) to .bashrc so everything lives in one place.
case $- in
  *i*) [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ] && . ~/.bashrc ;;
esac
