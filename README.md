# How to reproduce
## Installation from script
* Download the `SetupBootstrapper.ps1` file and run it as administrator.

This will start the installation, calling BoxStarter to run the `ChocolateyInstall.ps1` file as installation script.

All the separate parts are downloaded from the repo and installed during the installation. Reboots are executed correctly in between package installations.

## Installation from package
* Download the `TestCleanup.1.0.0.nupkg` from the repository to `C:\ProgramData\BoxStarter\BuildPackages`
* Download the `SetupBootstrapper.ps1` file
* Change the `$boxstarterPackage` variable value to `TestCleanup`
* Run the bootstrapper file as administrator

# Expected results
Reboots should be performed while the script is running, without running additional steps defined in the script before the steps before it are completed

# Observed results
The first method, installation from script URL, works fine.

The second method, installation from package, doesn't work properly: all steps from the script are executed, including final cleanup, before a reboot is executed.
