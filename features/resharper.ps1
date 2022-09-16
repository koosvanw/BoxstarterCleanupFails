#Installs Resharper ultimate

# Create cache location for the instalation as variable, so it can be appended to choco install commands
New-Item -Path "$env:userprofile\AppData\Local\ChocoCache" -ItemType directory -Force | Out-Null
$common = "--cacheLocation=`"$env:userprofile\AppData\Local\ChocoCache`""
$rootPath = "C:\Temp"
$progressFile = Join-Path -Path $rootPath "boxstarterInstallProgress.txt"
$progressCheck = "resharper"

# Create progress file if it doesn't exist
New-Item $progressFile  -ItemType "File" | Out-Null

$resharperFinished = Select-String -Path $progressFile $progressCheck

if ($null -eq $resharperFinished){
    Write-Host "Setting up Resharper ultimate"

    # resharper and vs extension
    choco upgrade resharper-ultimate-all -y $common
    choco upgrade resharper -y $common

    Write-Host "Finished setting up REsharper ultimate"
    Add-Content -Path $progressFile $progressCheck
}else{
    Write-Host "Skipping installation Resharper ultimate, already installed."
}
