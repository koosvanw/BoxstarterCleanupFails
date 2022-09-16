# All cleanup after install steps should be added here. This feature should always be included
$rootPath = "C:\Temp"

# Remove cache after installation
$cachePath = "$env:userprofile\AppData\Local\ChocoCache"
Remove-Item -Path $cachePath -Recurse -Force

# Remove progress file, if it exists
$progressFile = Join-Path -Path $rootPath "boxstarterInstallProgress.txt"
Remove-Item -Path $progressFile -Force -ErrorAction SilentlyContinue

# Empty recycle bin
Clear-RecycleBin -Force

# Display message with possible steps which should be taken after installation is complete
Add-Type -AssemblyName PresentationCore,PresentationFramework
$message = "Installation is finished!

You can now continue to setup your system as desired. 
Don't forget to correct you settings in your IDE to how they're supposed to be.
If you need to install additional tooling, software or any plugins, you can do that now."
[System.Windows.MessageBox]::Show($message, 'All done!')