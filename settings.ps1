Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$Buildinfo= "Patched : " + ((Get-Item "C:\Turing\patched.txt").CreationTime).tostring("MMMM yyyy")
$Installeddata = ((Get-Item "C:\Windows\Panther\setupact.etl").CreationTime).tostring("dd MMMM yyyy")
$Installinfo = "Turing User - Installed on : " + $Installeddata

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Value https://www.turingtrust.co.uk -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Value "Turing Trust" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOrganization" -Value $Buildinfo -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOwner" -Value $Installinfo -PropertyType String -Force | Out-Null

New-Item -Path "HKLM:\software\policies\microsoft\Edge"
New-Item -Path "HKLM:\software\policies\microsoft\EdgeUpdate"

New-ItemProperty -Path "HKLM:\software\policies\microsoft\Edge" -Name "HideFirstRunExperience" -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path "HKLM:\software\policies\microsoft\EdgeUpdate" -Name "UpdateDefault" -Value 3 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path "HKLM:\software\policies\microsoft\EdgeUpdate" -Name "InstallDefault" -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path "HKLM:\software\microsoft\windows\currentversion\policies\system" -Name "EnableFirstLogonAnimation" -Value 0 -PropertyType DWORD -Force | Out-Null

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetReleaseversion" -Value 1 -PropertyType DWORD -Force | Out-Null
#New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetReleaseversionInfo" -Value 21H2 -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetReleaseversionInfo" -Value 1909 -PropertyType String -Force | Out-Null # For Windows 32

New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force 

new-item -path "c:\Turing" -ItemType Directory -Force

Copy-Item -Path "\Software\turing\background.png" -Destination "C:\turing\Background.png"

Copy-Item -Path "\Software\User Account Pictures\*" -Destination "C:\ProgramData\Microsoft\User Account Pictures" -Recurse -Force

Set-LocalUser User1 -FullName "Turing User" -Description "Turing User"


powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0