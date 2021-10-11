
reg query hklm\system\currentcontrolset\control /v PEFirmwareType | find "2"

pause

if %errorlevel%==0 goto uefi
if %errorlevel%==1 goto bios
exit

:uefi
cls

echo Using UEFI XML File
setup /unattend:unattenduefi.xml
pause
exit

:bios
cls
pause

echo Using Bios XML File

setup /unattend:unattendbios.xml
pause
exit
