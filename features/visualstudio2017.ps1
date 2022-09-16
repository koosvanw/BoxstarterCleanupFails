# Create cache location for the instalation as variable, so it can be appended to choco install commands
New-Item -Path "$env:userprofile\AppData\Local\ChocoCache" -ItemType directory -Force | Out-Null
$common = "--cacheLocation=`"$env:userprofile\AppData\Local\ChocoCache`""
$rootPath = "C:\Temp"
$progressFile = Join-Path -Path $rootPath "boxstarterInstallProgress.txt"
$progressCheck = "VS2017"

# Create progress file if it doesn't exist
New-Item $progressFile  -ItemType "File" | Out-Null

$VS2017Finished = Select-String -Path $progressFile $progressCheck

if ($null -eq $VS2017Finished){
    Write-Host "Setting up VisualStudio 2017 professional with basic workloads"

    # VS2017
    choco upgrade visualstudio2017professional -y  $common
    choco upgrade visualstudio2017-workload-manageddesktop -y $common
    choco upgrade visualstudio2017-workload-visualstudioextension -y $common
    choco upgrade netfx-4.7.2-devpack -y $common

    Write-Host "Finished setting up VisualStudio 2017 professional"
    Add-Content -Path $progressFile $progressCheck
}else{
    Write-Host "Skipping installation of Visual Studio 2017 professional, already installed."
}