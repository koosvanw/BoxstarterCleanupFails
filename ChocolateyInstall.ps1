$featuresDir = 'https://raw.githubusercontent.com/koosvanw/BoxstarterCleanupFails/master/features'

function installFeature {
    Param ([string]$feature)
    write-host "executing $feature ..."

	Invoke-Expression ((new-object net.webclient).DownloadString("$featuresDir\$feature"))
 }

# Install basics
installFeature("basetooling.ps1")

# Visual Studio 2017 and 2019 both, for VACAM and TwinCAT development
installFeature("visualstudio2017.ps1")
installFeature("visualstudio2019.ps1")
installFeature("visualstudio2022.ps1")
installFeature("resharper.ps1")
installFeature("vsExtensions.ps1")

# Make sure everything is cleaned up nicely afterwards
installFeature("cleanup.ps1")
