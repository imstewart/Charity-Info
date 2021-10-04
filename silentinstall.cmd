@echo ff
reg query hklm\system\currentcontrolset\control /v PEFirmwareType | find "2"

if %errorlevel%==0 goto uefi
if %errorlevel%==1 goto bios
exit

:uefi
cls
z:
echo Using UEFI XML File
setup /unattend:unattenduefi.xml
pause
exit

:bios
cls
echo Using Bios XML File
z:
setup /unattend:unattendbios.xml
pause
exit
