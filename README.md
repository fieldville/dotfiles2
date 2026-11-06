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

Starship reads `.posh/starship.toml` through `STARSHIP_CONFIG`, set by `.bashrc`, `.zshrc`
and the PowerShell profile from their own location, so no `~/.config/starship.toml` link
is needed.

zsh (macOS default shell):
--------------------------

`.zshrc` / `.zprofile` are the zsh counterpart of `.bashrc` / `.profile` (plain zsh +
Starship, no oh-my-zsh). Both shells source the same alias files (`.alias`, `.galias`,
`.falias`) and share the Starship config, so linking this repo alone is enough.
zsh-autosuggestions / zsh-syntax-highlighting are optional and picked up from Homebrew
or the Ubuntu packages when installed:

```
$ brew install starship zsh-autosuggestions zsh-syntax-highlighting fzf zoxide   # macOS
$ sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting               # Ubuntu / WSL
$ ./setup.bash                                                                   # links .zshrc and .zprofile among the rest
```

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

Both files are read by bash and zsh alike, so keep them to syntax both accept. The
PowerShell counterpart is `~\.alias.private.ps1`.

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
