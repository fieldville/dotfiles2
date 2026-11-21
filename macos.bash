#!/usr/bin/env bash
#
# macOS-only settings that are not dotfiles (written with `defaults`). Safe to rerun.
#
#   ./macos.bash

set -u
[[ $(uname) == Darwin ]] || { echo "macos.bash: not macOS, nothing to do"; exit 0; }

# Terminal.app: move "Split Pane" off Cmd-D (it only gets in the way under byobu / tmux)
# onto Ctrl-Opt-Shift-Cmd-D. A menu shortcut cannot be removed, only reassigned, and the
# key must equal the menu title in the UI language, so set the English and Japanese ones.
# Modifiers: @ = Cmd, ~ = Opt, ^ = Ctrl, $ = Shift.
for title in 'Split Pane' '分割パネル'; do
  defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add "$title" '@~^$d'
done
echo "  Terminal.app: Split Pane moved off Cmd-D (restart Terminal to apply)"

# VS Code: turn off press-and-hold (the accent-character popup) so that holding hjkl in
# VSCodeVim repeats the key and keeps moving the cursor. Affects VS Code only.
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
echo "  VS Code: press-and-hold off, held keys repeat (quit VS Code with Cmd-Q and restart to apply)"
