#!/usr/bin/env bash
#
# Symlink each dotfile in this repo into $HOME, asking per file.
#
#   ./setup.bash        ask for each file (y / n / a = yes to all / q = quit)
#   ./setup.bash -y     link everything without asking
#
# Then installs what Brewfile lists but is missing (asks first; -y installs).

set -u
cd "$(dirname "$0")" || exit 1
repo=$(basename "$PWD")

yes_all=0
[[ ${1:-} == -y ]] && yes_all=1

link() {
  (cd ~ && ln -fs "$repo/$1" .) && echo "  linked ~/$1 -> $repo/$1"
}

# Describe what currently sits at ~/$1 so the user can decide.
status() {
  local t=~/$1
  if [[ -L $t ]]; then
    local dest; dest=$(readlink "$t")
    if [[ $dest == "$repo/$1" ]]; then echo "already linked"
    else echo "symlink -> $dest"
    fi
  elif [[ -e $t ]]; then echo "exists (will be overwritten)"
  else echo "new"
  fi
}

for f in $(find . -mindepth 1 -maxdepth 1 -name '.*' ! -name '.git' ! -name '.*swp' ! -name '.vscode' ! -name '.zcompdump*' \
             | sed 's|^\./||' | sort); do
  if (( yes_all )); then
    link "$f"
    continue
  fi

  read -rp "$f  [$(status "$f")]  link? (y/N/a/q) " -n 1
  echo
  case $REPLY in
    [Yy]) link "$f" ;;
    [Aa]) yes_all=1; link "$f" ;;
    [Qq]) echo "aborted"; exit 0 ;;
    *)    echo "  skipped $f" ;;
  esac
done

# Tools the rc files load only when installed (see Brewfile). A missing one fails
# silently (no zsh-autosuggestions = no suggestions, and no error), so check here.
if command -v brew >/dev/null 2>&1; then
  if report=$(brew bundle check --verbose --no-upgrade --file=Brewfile 2>&1); then
    echo "Brewfile  [all installed]"
  else
    missing=$(sed -n 's/.* \([^ ]*\) needs to be installed.*/\1/p' <<<"$report" | paste -sd' ' -)
    if (( yes_all )); then
      brew bundle install --no-upgrade --file=Brewfile
    else
      read -rp "Brewfile  [missing: ${missing:-some packages}]  install? (y/N) " -n 1
      echo
      if [[ $REPLY == [Yy] ]]; then
        brew bundle install --no-upgrade --file=Brewfile
      else
        echo "  skipped: the shell will start without ${missing:-them}"
      fi
    fi
  fi
else
  # No Homebrew: only report. The zsh plugins are then looked up in /usr/share (apt).
  missing=
  for p in zsh-autosuggestions zsh-syntax-highlighting; do
    [[ -f /usr/share/$p/$p.zsh ]] || missing+=" $p"
  done
  for c in starship fzf zoxide; do
    command -v "$c" >/dev/null 2>&1 || missing+=" $c"
  done
  if [[ -n $missing ]]; then
    echo "not installed, the shell will start without:$missing"
    echo "  install Homebrew and rerun this script, or see README (apt on Ubuntu)"
  fi
fi

# macOS: apply the settings that are not dotfiles (see macos.bash).
if [[ $(uname) == Darwin ]]; then
  if (( yes_all )); then
    ./macos.bash
  else
    read -rp "macos.bash  [macOS settings via defaults]  run? (y/N) " -n 1
    echo
    [[ $REPLY == [Yy] ]] && ./macos.bash
  fi
fi
