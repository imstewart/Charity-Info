@echo off
echo Applying Taskbar settings
reg.exe add HKCU\software\microsoft\windows\currentversion\explorer\advanced /v TaskbarAl /t REG_DWORD /d 0 /f
reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f
reg.exe add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
reg.exe add HKLM\Software\Policies\Google\Chrome\PromotionalTabsEnabled /t REG_DWORD /d 0 /f
echo Set Chrome as Default Browser
c:\Turing\software\SetDefaultBrowser.exe chrome
Echo Set Default Start Menu
copy "C:\TURING\Settings\StartMenu\start2.bin" %LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin /y
Echo Reset Assocation defaults
Dism.exe /Online /Remove-DefaultAppAssociations
dism /online /Import-DefaultAppAssociations:"C:\TURING\Settings\Assocations\DefaultAppAssociations.xml"
Echo Set background Wallpaper
C:\Turing\software\Bginfo64.exe c:\turing\software\turing.bgi /timer:0 /nolicprompt /silent 
Set Application Defaults
xcopy "C:\TURING\Settings\RapidTyping 5\*" "C:\ProgramData\RapidTyping 5\*" /s /e /y > null
xcopy "C:\TURING\Settings\Scratch\*" "C:\Users\User1\AppData\Roaming\Scratch\*" /s /e /y > null
xcopy "C:\TURING\Settings\vlc\*" "C:\Users\User1\AppData\Roaming\vlc\*" /s /e /y > null 
Echo System will restart once your press ENTER
pause
shutdown /r /f /t 30