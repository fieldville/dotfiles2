dotfiles2
=========

The conservative, bash-only dotfiles. Same layout as
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

Starship reads `.posh/starship.toml` through `STARSHIP_CONFIG`, set by `.bashrc` and the
PowerShell profile from their own location, so no `~/.config/starship.toml` link is needed.

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
