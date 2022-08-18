$Buildinfo= "Patched : " + ((Get-Item "C:\Turing\patched.txt").CreationTime).tostring("MMMM yyyy")
$Installeddata = ((Get-Item "C:\ProgramData\Microsoft\XboxLive").CreationTime).tostring("dd MMMM yyyy")
$Installinfo = "Turing User - Installed on - " + $Installeddata

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Value https://www.turingtrust.co.uk -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Value "Turing Trust" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOrganization" -Value $Buildinfo -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOwner" -Value $Installinfo -PropertyType String -Force | Out-Null