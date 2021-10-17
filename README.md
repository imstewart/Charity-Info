# Charity-Info
Information to setup infrastruture

# Location of files:

1. Files in the unattended folder should be copied to the Z:
2. Install.cmd and the Turing_setting.ps1 files should be placed in a share that doesn't required authenication
3. Turing folder should be placed in the same folder as point 2

Once the Powershell has run a reboot is required to apply any patches.

Current share: \\192.168.0.220\deploy  Drivers and deployment share

Files that required to be updated to make this work

1. XML Files: 
    Line needs to be updated with the location of the drives, this needs to be a location that doesn't require authenication
    
    Driver location
    
        <Path>cmd /c reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion /v DevicePath /t REG_EXPAND_SZ /d "%SystemRoot%\inf;\\192.168.0.220\deploy\drivers" /f</Path>
    
    Install continuation script: 
    
        <CommandLine>cmd.exe /c \\192.168.0.220\deploy\install.cmd</CommandLine>
        
2. Install continuation script
    
    Install.cmd
        PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy bypass -File ""\\192.168.0.220\deploy\turing_settings.ps1""' -Verb RunAs}";


3.  Powershell script that is called in the Install.cmd

    Turing_Settings.ps1
          
          $file_location = "\\192.168.0.220\deploy\turing"
          
          
          
          
 
