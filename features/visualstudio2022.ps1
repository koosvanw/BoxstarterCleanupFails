# Create cache location for the instalation as variable, so it can be appended to choco install commands
New-Item -Path "$env:userprofile\AppData\Local\ChocoCache" -ItemType directory -Force | Out-Null
$common = "--cacheLocation=`"$env:userprofile\AppData\Local\ChocoCache`""
$rootPath = "C:\Temp"
$progressFile = Join-Path -Path $rootPath "boxstarterInstallProgress.txt"
$progressCheck = "VS2022"

# Create progress file if it doesn't exist
New-Item $progressFile  -ItemType "File" | Out-Null

$VS2019Finished = Select-String -Path $progressFile $progressCheck

if ($null -eq $VS2022Finished){
    Write-Host "Setting up VisualStudio 2022 professional with basic workloads"

    # VS2019
    choco upgrade visualstudio2022professional -y $common
    choco upgrade visualstudio2022-workload-manageddesktop -y $common

    Write-Host "Finished setting up VisualStudio 2022 professional"
    
    Add-Content -Path $progressFile $progressCheck
} else{
    Write-Host "Skipping Visual Studio 2022 Professional installation, already done."
}
