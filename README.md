dotfiles2
=========

The conservative dotfiles: bash and zsh on Unix, PowerShell on Windows. Same layout as
[dotfiles](https://github.com/fieldville/dotfiles): each dotfile sits at the repo root
and is symlinked into `~`.

Installation:
------------

```
$ git clone git@github.com:fieldville/dotfiles2.git ~/.dotfiles2
$ cd ~/.dotfiles2
$ ./setup.bash
```

`setup.bash` asks per file whether to link it into `~` (`y` / `n` / `a` = all / `q` = quit).
Use `./setup.bash -y` to link everything without asking. To pick up a layout change
after `git pull`, just run it again; it relinks in place.

After the links it checks the tools in `Brewfile` (Starship, the zsh plugins, fzf,
zoxide) and offers to install the missing ones with Homebrew (`-y` installs without
asking). The rc files load each tool only when it is installed, so a missing one gives
no error, just a shell without it; this check is what tells you. Without Homebrew it
only lists what is missing.

Starship reads `.posh/starship.toml` through `STARSHIP_CONFIG`, set by `.bashrc`, `.zshrc`
and the PowerShell profile from their own location, so no `~/.config/starship.toml` link
is needed. That config replaces every default symbol that needs a Nerd Font, so the
prompt renders with the stock terminal fonts and no font has to be installed.

zsh (macOS default shell):
--------------------------

`.zshrc` / `.zprofile` are the zsh counterpart of `.bashrc` / `.profile` (plain zsh +
Starship, no oh-my-zsh). Both shells source the same alias files (`.alias`, `.galias`,
`.falias`) and share the Starship config, so linking this repo alone is enough.
zsh-autosuggestions / zsh-syntax-highlighting are optional and picked up from Homebrew
or the Ubuntu packages when installed:

```
$ sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting   # Ubuntu / WSL only
$ ./setup.bash                                                       # links .zshrc and .zprofile, installs Brewfile (macOS)
```

No suggestions while typing on a new machine means zsh-autosuggestions is not installed:
rerun `./setup.bash`, or `brew bundle --file=~/.dotfiles2/Brewfile`.

macOS Terminal and iTerm already start zsh; elsewhere run `chsh -s "$(command -v zsh)"`
and log in again.

Machine-local settings:
-----------------------

Settings that belong to one machine only live in `~`, outside this repo, and are sourced
when present:

| File | Sourced from | For |
| --- | --- | --- |
| `~/.profile.private` | `.zprofile` / `.profile` (login shell) | `PATH`, `export`s, tokens |
| `~/.alias.private` | `.zshrc` / `.bashrc` (interactive shell) | aliases, functions, completions |
| `~/.rc.private` | `.zshrc` / `.bashrc`, at the very end | overrides that must win, e.g. the front of `PATH` |

All of them are read by bash and zsh alike, so keep them to syntax both accept. The
PowerShell counterpart is `~\.alias.private.ps1`.

`.zshrc` / `.bashrc` prepend several directories to `PATH` (fnm, cargo, `~/.local/bin`,
...) after `~/.profile.private` has run, so to put a directory first, do it in
`~/.rc.private`. For example, Homebrew first:

```sh
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
```

macOS settings:
---------------

`macos.bash` applies the macOS settings that are not dotfiles, through `defaults`. On
macOS `setup.bash` offers to run it after the links (`-y` runs it without asking); it is
safe to rerun, and can be run on its own:

```
$ ./macos.bash
```

| Setting | Why |
| --- | --- |
| Terminal.app: "Split Pane" moved from Cmd-D to Ctrl-Opt-Shift-Cmd-D | Cmd-D splits the window, which is useless under byobu / tmux; restart Terminal to apply |

Windows (PowerShell):
---------------------

```
PS> git clone git@github.com:fieldville/dotfiles2.git ~/.dotfiles2
PS> cd ~/.dotfiles2
PS> powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

This makes `$PROFILE` dot-source `.posh/PowerShell/Microsoft.PowerShell_profile.ps1`
and installs the tools and modules it uses. Run it once in each shell (Windows
PowerShell and pwsh keep separate `$PROFILE`s), and again after a `git pull` that
moves the profile.
