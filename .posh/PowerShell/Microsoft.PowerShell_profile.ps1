# $user = "username"
# $password = "***********"
# $proxyhost = "proxy.co.jp:3128"
# $proxyaddress = "http://$($proxyhost)/"
# $env:http_proxy = "http://$($user):$($password)@$($proxyhost)"
# $env:https_proxy = "http://$($user):$($password)@$($proxyhost)"
# $env:ftp_proxy = "http://$($user):$($password)@$($proxyhost)"
# $password_secure = ConvertTo-SecureString $password -AsPlainText -Force
# $creds = New-Object System.Management.Automation.PSCredential $user, $password_secure
# $proxy = New-Object System.Net.WebProxy $proxyaddress
# $proxy.Credentials = $creds
# [System.Net.WebRequest]::DefaultWebProxy = $proxy
# $env:chocolateyProxyUser = $user
# $env:chocolateyProxyPassword = $password
# $env:chocolateyProxyLocation = $proxyaddress
# # choco config set proxy $proxyhost
# # choco config set proxyUser $user
# # choco config set proxyPassword $password

Import-Module PSReadline
Set-PSReadlineOption -EditMode Emacs
#Set-PSReadlineOption -EditMode vi
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
#Set-PSReadlineKeyHandler -Key 'Ctrl+r' -Function ReverseSearchHistory
#Set-PSReadlineKeyHandler -Key 'Ctrl+s' -Function ForwardSearchHistory
#Set-PSReadlineKeyHandler -Key 'Ctrl+k' -Function KillLine
#Set-PSReadlineKeyHandler -Key 'Ctrl+u' -Function BackwardKillLine

# Ctrl+x, Ctrl+e: edit the current command line in $env:EDITOR (like bash's edit-and-execute-command).
# Useful for pasting / editing multi-line scriptlets; the buffer is replaced on save & quit.
# NOTE: ViEditVisually resolves $env:EDITOR via Get-Command as a single application with no
# arguments, so e.g. 'code --wait' does not work; nvim blocks until exit and works as-is.
if (-not $env:EDITOR) { $env:EDITOR = 'nvim' }
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+e' -Function ViEditVisually

# fzf via PSFzf (PowerShell counterpart of `eval "$(fzf --bash)"` in .bashrc):
# Ctrl+r = fuzzy history search (replaces ReverseSearchHistory),
# Ctrl+t = fuzzy file-path picker (replaces Emacs SwapCharacters).
# Install: `winget install junegunn.fzf` and `Install-Module PSFzf -Scope CurrentUser`.
# NOTE: Windows PowerShell 5.1 and pwsh use separate module dirs
# (Documents\WindowsPowerShell\Modules vs Documents\PowerShell\Modules), so run
# Install-Module from BOTH shells. Skipped silently when either piece is missing,
# so a fresh machine still starts cleanly with PSReadLine's default bindings.
if ((Get-Command fzf -ErrorAction Ignore) -and (Get-Module -ListAvailable PSFzf)) {
  Import-Module PSFzf
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# fzf helper functions (fkill, fbr, fco, fshow, gadd, fstash, fda, ...) and the FZF_*
# defaults: counterpart of `source ~/.falias` in .bashrc, see falias.ps1.
# Needs fd / rg (bat optional) for the defaults; setup.ps1 installs them.
if (Get-Command fzf -ErrorAction Ignore) {
  . (Join-Path $PSScriptRoot 'falias.ps1')
}

#Import-Module DockerCompletion
#Import-Module posh-docker
#Import-Module posh-git
#Import-Module oh-my-posh
#Set-PoshPrompt -Theme paradox
#Set-PoshPrompt -Theme robbyrussell
#Set-PoshPrompt -Theme avit
#Set-PoshPrompt -Theme rudolfs-light
#Set-PoshPrompt -Theme rudolfs-dark
#Set-PoshPrompt -Theme honukai

# Starship prompt (https://starship.rs/). Install via WinGet:
#   winget install --id Starship.Starship
# The default preset uses Nerd Font glyphs; install one and select it in the terminal, e.g.:
#   winget install --id DEVCOM.JetBrainsMonoNerdFont
# Config: .posh/starship.toml in this repo, pointed to via $env:STARSHIP_CONFIG so no
# symlink into $env:USERPROFILE\.config is needed (a value already set elsewhere wins).
# Skipped silently when starship is not installed yet, so a fresh machine still starts cleanly.
if (Get-Command starship -ErrorAction Ignore) {
  if (-not $env:STARSHIP_CONFIG) {
    $env:STARSHIP_CONFIG = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\starship.toml'))
  }
  Invoke-Expression (&starship init powershell)
}

# tig: use .tigrc in this repo (vim-like g/G to first/last line, custom binds).
# tig reads $TIGRC_USER instead of ~/.tigrc, so no symlink is needed; forward slashes keep
# the MSYS2 build shipped alongside Git for Windows happy. A value already set elsewhere wins.
if (-not $env:TIGRC_USER) {
  $env:TIGRC_USER = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\.tigrc')) -replace '\\', '/'
}

# tig binary: there is no winget/scoop package, but Git for Windows ships tig.exe (MSYS2 build)
# in <git root>\usr\bin, which is deliberately NOT on PATH (it also holds find/sort/...).
# Locate it through `git --exec-path` (<root>\{mingw64,ucrt64}\libexec\git-core) so this works
# for both the scoop and the winget (C:\Program Files\Git) installs, and expose usr\bin only
# for the duration of the tig process so the `!sh -c ...` binds in .tigrc work.
# A tig already on PATH (e.g. Git Bash, or a hand-installed one) wins, nothing is shadowed then.
if (-not (Get-Command tig -CommandType Application -ErrorAction Ignore)) {
  function tig {
    $execPath = git --exec-path 2>$null
    if (-not $execPath) { Write-Error "tig: git not found"; return }
    $gitRoot = Split-Path (Split-Path (Split-Path $execPath -Parent) -Parent) -Parent
    $usrBin  = Join-Path $gitRoot 'usr\bin'
    $exe     = Join-Path $usrBin 'tig.exe'
    if (-not (Test-Path $exe)) { Write-Error "tig: not found at $exe (is Git for Windows installed?)"; return }

    $oldPath = $env:PATH
    try {
      $env:PATH = "$usrBin;$env:PATH"
      & $exe @args
    } finally {
      $env:PATH = $oldPath
    }
  }
}

# editor: mirrors `alias vi=nvim` / `view='nvim -R'` / `vimdiff='nvim -d'` in .alias (bash).
# Set-Alias cannot carry arguments, so `view` and `vimdiff` are functions.
Set-Alias vi nvim
function view { nvim -R @args }
function vimdiff { nvim -d @args }

# rm / find: Unix semantics via busybox (frippery.busybox-w32, installed by setup.ps1), so
# `rm -rf x` and `find . -name '*.log'` work as in bash. PowerShell resolves aliases before
# functions, so the built-in rm alias (Remove-Item) has to go first or the function never runs.
# fd is the usual day-to-day tool; `find` is for muscle memory and copy-pasted one-liners.
if (Test-Path alias:rm) { Remove-Item alias:rm -Force }
function rm { busybox rm @args }
function find { busybox find @args }

# ls / l / ll / la: `ls` stays the built-in alias for Get-ChildItem. l/ll/la mirror .alias
# (l='ls', ll='ls -ltrh', la='ll -A') in Get-ChildItem terms: `-ltr` = sort by mtime, newest last;
# `-A` = -Force (hidden/system files; PowerShell never lists . and ..). Set-Alias cannot
# carry arguments, so these have to be functions.
# `-h` has no Get-ChildItem equivalent, so ll/la render their own table with a Size column
# (4.0K, 12K, 1.5M ... like GNU ls) when they are the last command in the pipeline. When
# something is piped after them (`ll | Where-Object ...`) they emit plain FileSystemInfo
# objects instead, so filtering/sorting keeps working. Note `$x = ll` captures the table.
function ConvertTo-HumanSize ([long]$Bytes) {
  if ($Bytes -lt 1024) { return "$Bytes" }
  $v = [double]$Bytes; $i = -1
  foreach ($u in 'K', 'M', 'G', 'T', 'P') { $v /= 1024; $i++; if ($v -lt 1024) { break } }
  $fmt = if ($v -lt 10) { '{0:0.0}{1}' } else { '{0:0}{1}' }
  [string]::Format([cultureinfo]::InvariantCulture, $fmt, $v, ('K', 'M', 'G', 'T', 'P')[$i])
}

# Name colouring as the default Get-ChildItem view does it ($PSStyle.FileInfo, pwsh 7.2+);
# Windows PowerShell 5.1 has no $PSStyle and gets plain names.
function Format-LsName ($Item) {
  if (-not $PSStyle) { return $Item.Name }
  $fi = $PSStyle.FileInfo
  $color =
    if ($Item.PSIsContainer) { $fi.Directory }
    elseif ($Item.Attributes -band [IO.FileAttributes]::ReparsePoint) { $fi.SymbolicLink }
    elseif ($fi.Extension.ContainsKey($Item.Extension)) { $fi.Extension[$Item.Extension] }
    elseif (($env:PATHEXT -split ';') -contains $Item.Extension) { $fi.Executable }
    else { '' }
  if ($color) { "$color$($Item.Name)$($PSStyle.Reset)" } else { $Item.Name }
}

$LsLongColumns = @(
  'Mode', 'LastWriteTime',
  @{ Label = 'Size'; Align = 'Right'; Expression = { if ($_.PSIsContainer) { '' } else { ConvertTo-HumanSize $_.Length } } },
  @{ Label = 'Name'; Expression = { Format-LsName $_ } }
)

function l { Get-ChildItem @args }
function ll {
  $items = Get-ChildItem @args | Sort-Object LastWriteTime
  if ($MyInvocation.PipelineLength -eq $MyInvocation.PipelinePosition) { $items | Format-Table $LsLongColumns } else { $items }
}
function la {
  $items = Get-ChildItem -Force @args | Sort-Object LastWriteTime
  if ($MyInvocation.PipelineLength -eq $MyInvocation.PipelinePosition) { $items | Format-Table $LsLongColumns } else { $items }
}

function which ($command) {
  Get-command -Name $command -ShowCommandInfo | Format-List -Property Definition
}

# ---------------------------------------------------------------------------
# Git aliases: mirrors the "aliases for git" section of .alias (bash).
# Keep the two in sync when adding one. PowerShell resolves aliases before
# functions, so built-in aliases that collide with ours (gc=Get-Content,
# gl=Get-Location, gp=Get-ItemProperty, gm=Get-Member, gcm=Get-Command,
# gci=Get-ChildItem) are removed first; otherwise the functions never run.
# ---------------------------------------------------------------------------
foreach ($name in 'gl', 'gc', 'gp', 'gm', 'gcm', 'gci') {
  if (Test-Path "alias:$name") { Remove-Item "alias:$name" -Force }
}

Set-Alias g git
Set-Alias get git

# clone / add / reset
function gcl { git clone @args }
function ga { git add @args }
function gall { git add . }
function grh { git reset HEAD @args }
function grhh { git reset HEAD --hard @args }
function gclean { git reset --hard; if ($LASTEXITCODE -eq 0) { git clean -dfx } }

# status
function gst { git status @args }
function gs { git status @args }
function gss { git status -s @args }

# pull / push / fetch
function gl { git pull @args }
function gpr { git pull --rebase @args }
function glr { git pull --rebase @args }   # PowerShell-only (kept for existing habit)
function gpp { git pull; if ($LASTEXITCODE -eq 0) { git push } }
function gup { git fetch; if ($LASTEXITCODE -eq 0) { git rebase @args } }
function gp { git push @args }
function gpo { git push origin @args }

# diff
function gd { git diff @args }
function gdv { git diff -w @args | nvim -R - }

# commit
function gc { git commit -v @args }
function gca { git commit -v -a @args }
function gci { git commit --interactive @args }

# checkout / branch / merge / cherry-pick
function gco { git checkout @args }
function gcm { git checkout main }
function gcma { git checkout master }
function gb { git branch @args }
function gba { git branch -a @args }
function gbr { git branch --remote @args }
function gdel { git branch -D @args }
function gm { git merge @args }
function gmu { git fetch origin -v; git fetch upstream -v; git merge upstream/main }
function gmua { git fetch origin -v; git fetch upstream -v; git merge upstream/master }
function gcp { git cherry-pick @args }

# rebase
function grbi { git rebase -i @args }
function grbc { git rebase --continue }
function grba { git rebase --abort }

# log
function gll { git log --graph --pretty=oneline --abbrev-commit @args }
function gg { git log --graph '--pretty=format:%h -%d %s (%cr)' --abbrev-commit --date=relative @args }
function ggs { gg --stat @args }
function glg { git log --stat --max-count=10 @args }
function glgg { git log --graph --max-count=10 @args }
function glgga { git log --graph --decorate --all @args }
function glo { git log --oneline --decorate --color @args }
function glog { git log --oneline --decorate --color --graph @args }
function gw { git whatchanged @args }
function gcount { git shortlog -sn @args }
function gsl { git shortlog -sn @args }

# tag
function gt { git tag @args }
function gta { git ls-remote --tags @args }
function gtd { git tag -d @args }
function gtl { git tag -l @args }

# remote
function grv { git remote -v }
function grmv { git remote rename @args }
function grrm { git remote remove @args }
function grset { git remote set-url @args }
function grup { git remote update @args }

# config
function gcfg { git config --list @args }
function gori { git config --list --show-origin @args }   # PowerShell-only

# stash
function gsta { git stash @args }
function gstp { git stash pop @args }
function gstd { git stash drop @args }
function gsts { git stash show --text @args }

# misc
function gexport { git archive --format zip --output @args }
function grt {
  # cd to the repository root (bash: cd $(git rev-parse --show-cdup))
  $top = git rev-parse --show-toplevel 2>$null
  if ($top) { Set-Location $top }
}

function egrep { egrep --color=auto $args }
function fgrep { fgrep --color=auto $args }
function grep { grep --color --exclude-dir='{.git,.svn}' --exclude=\*.html\* $args }

# for docker
function dco { docker-compose $args }
function dps { docker ps $args }
function ds { docker images; docker ps -a }
function da { docker ps -a }

#Set-Alias docker 'C:\Program Files\Docker\Docker\Resources\bin\docker.exe'
#Set-Alias kubectl 'C:\Program Files\Docker\Docker\Resources\bin\kubectl.exe'

# zoxide as `j` / `ji` (interactive via fzf): PowerShell counterpart of
# `eval "$(zoxide init bash --cmd j)"` in .bashrc. Install: `winget install ajeetdsouza.zoxide`.
# Kept at the end of the profile: on Windows PowerShell 5.1 zoxide hooks the prompt
# function, so it has to run after Starship has defined it. Skipped silently when missing.
if (Get-Command zoxide -ErrorAction Ignore) {
  Invoke-Expression (& { (zoxide init powershell --cmd j | Out-String) })
}

#Set-Location C:\
