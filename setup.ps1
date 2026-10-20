# Windows counterpart of setup.bash: make $PROFILE dot-source the profile in this repo
# so that `git pull` alone picks up changes, and install the PowerShell modules the
# profile uses. Run once per shell (Windows PowerShell / pwsh), since each has its own
# $PROFILE and its own user module dir:
#   powershell -ExecutionPolicy Bypass -File .\setup.ps1
#   pwsh -ExecutionPolicy Bypass -File .\setup.ps1

$src  = Join-Path $PSScriptRoot "home\.posh\PowerShell\Microsoft.PowerShell_profile.ps1"
$line = ". '$src'"

if ((Test-Path $PROFILE) -and (Select-String -Path $PROFILE -SimpleMatch $line -Quiet)) {
  "Already set up: $PROFILE"
} else {
  if (Test-Path $PROFILE) {
    Copy-Item $PROFILE "$PROFILE.bak" -Force
    "Backed up existing profile to $PROFILE.bak"
  }
  New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE) | Out-Null
  Set-Content -Path $PROFILE -Value $line
  "Wrote $PROFILE -> $src"
}

# Modules used by the profile. Installed per shell on purpose: Windows PowerShell 5.1 and
# pwsh keep separate user module dirs (Documents\WindowsPowerShell\Modules vs
# Documents\PowerShell\Modules), so a module installed from one is invisible to the other.
# PSFzf also needs the fzf binary itself: `winget install junegunn.fzf`.
$modules = @('PSFzf')

# PowerShell 5.1 defaults to TLS 1.0/1.1, which the PowerShell Gallery no longer accepts.
if ($PSVersionTable.PSVersion.Major -lt 6) {
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
}

foreach ($m in $modules) {
  if (Get-Module -ListAvailable -Name $m) {
    "Already installed: $m"
    continue
  }
  "Installing $m ..."
  Install-Module -Name $m -Scope CurrentUser -Force
  "Installed $m"
}
