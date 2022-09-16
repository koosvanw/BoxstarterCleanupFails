# Create cache location for the instalation as variable, so it can be appended to choco install commands
New-Item -Path "$env:userprofile\AppData\Local\ChocoCache" -ItemType directory -Force | Out-Null
$common = "--cacheLocation=`"$env:userprofile\AppData\Local\ChocoCache`""
$rootPath = "C:\Temp"
$progressFile = Join-Path -Path $rootPath "boxstarterInstallProgress.txt"
$progressCheck = "basetooling"

# Create progress file if it doesn't exist
New-Item $progressFile  -ItemType "File" -ErrorAction SilentlyContinue

$baseToolingFinished = Select-String -Path $progressFile $progressCheck

if ($null -eq $baseToolingFinished){
  Write-Host "Installing windows terminal"
  choco upgrade microsoft-windows-terminal -y $common
  Write-Host "Installing Vredist 2015-2019"
  choco upgrade vcredist140 -y $common
  Write-Host "Installing git"
  choco upgrade git.install -y --params "'/SChannel'" $common
  Write-Host "Installing gitext"
  choco upgrade gitextensions -y $common

  # Set path for installation of VsCode extensions
  Write-Host "Installing VS code"
  choco upgrade vscode -y $common
  Write-Host "Installing VS code live share"
  choco upgrade vscode-vsliveshare -y $common
  Write-Host "Installing kdiff3"
  choco upgrade kdiff3 -y $common
  Write-Host "Installing Vlc"
  choco upgrade vlc -y $common
  Write-Host "Installing Open SSH"
  choco upgrade openssh -y $common
  Write-Host "Installing sysinternals"
  choco upgrade sysinternals -y $common
  Write-Host "Installing crystal disk info"
  choco upgrade crystaldiskinfo -y $common
  Write-Host "Installing windirstat"
  choco upgrade windirstat -y $common
  
} else{
  Write-Host "Skipping $progressCheck installation, already done."
}