export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# For interactive login shells, defer the rest (aliases, history, prompt,
# starship) to .bashrc so everything lives in one place.
case $- in
  *i*) [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ] && . ~/.bashrc ;;
esac
