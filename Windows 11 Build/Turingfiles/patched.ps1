Write-Host "Install the available patches and drivers for this PC" -ForegroundColor Yellow

Install-PackageProvider -name nuget -force
Set-PSRepository -Name PSgallery -InstallationPolicy Trusted
Install-Module PSWindowsUpdate
Import-Module PSWindowsUpdate
Get-WindowsUpdate -nottitle ".Cumulative." -Install -AcceptAll -IgnoreReboot | Format-Table