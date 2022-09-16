#installs extensions into vs
New-Item -Path "$env:userprofile\AppData\Local\ChocoCache" -ItemType directory -Force | Out-Null
$common = "--cacheLocation=`"$env:userprofile\AppData\Local\ChocoCache`""

Write-Host "installing codemaid"
choco upgrade codemaid -y $common
Write-Host "Installing trailing whitespace visualizer"
choco upgrade trailingwhitespace -y $common
Write-Host "Installing vscolor"
choco upgrade vscoloroutput -y $common
