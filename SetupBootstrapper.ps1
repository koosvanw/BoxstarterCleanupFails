# Check if the process is started with administrator rights. If not, request admin rights and restart it.
if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
  Exit
 }

 $boxstarterPackage = "https://raw.githubusercontent.com/koosvanw/BoxstarterCleanupFails/master/ChocolateyInstall.ps1"

# Bootstrapper script for the installation. 
# Bootstrapper performs actions which are required for every role installation
# and in turn kicks off the actual installation script depending on the given argument
$tempPath = "C:\Temp"
$ErrorActionPreference = 'Stop'

function Set-RequiredPreparation {
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value 1
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value 1

  # Temporarily set execution policy to unrestricted for displaying of popup messages
  Set-ExecutionPolicy Unrestricted -Force

  # Make sure installations succeed with nested installs (boxstarter behavior)
  Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -value 1
}

function CheckCredentials{
  param (
[Parameter()] $Credentials
)
  try {
    Start-Process "Cmd.exe" -argumentlist "/c","echo" -Credential $Cred
    return $True
  } catch {
    return $False
  }
}

function Get-AdminCredentials {
  $user = whoami
  $cred = Get-Credential -User $user -Message "Provide admin password in order to automatically login after reboots" 
  $CredOk = CheckCredentials -Credentials $cred
  if ($CredOk -eq $False){
    Write-Host 'Invalid admin credentials were entered!'
    return $null
  }
  return $cred
}

function Install-Chocolatey {
  # Install chocolatey. Start new session with installation. Installing from this session
  # fails because of variables not being written correctly.
  $InstallChocoScript = {
    "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
  }
  Start-Process -FilePath "powershell" -Verb RunAs -Wait -ArgumentList $InstallChocoScript
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

function Install-Boxstarter {
  # Install BoxStarter and add the modules to the current session in order to start installation
  # using BoxStarter when the installation script has been composed.
  cinst boxstarter -y
  $env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath","Machine")
  Import-Module Boxstarter.Chocolatey
}

Set-RequiredPreparation

# Get credentials which can be used to logon again after reboots
$cred = Get-AdminCredentials
if ($cred -eq $null){
  Write-Host 'Admin credentials are invalid, restart the script and try again' 
  exit
}

Install-Chocolatey
Install-Boxstarter

# Call BoxStarter installation with proper script file and credentials
Install-BoxstarterPackage -PackageName "$boxstarterPackage" -Credential $cred
