   $Activation_status = Get-CIMInstance -query "select Name, Description, LicenseStatus from SoftwareLicensingProduct where LicenseStatus=1" | select LicenseStatus
    if ($Activation_status.LicenseStatus -eq 1) 
        { 
            Write-Host  "Info  : " -NoNewline -ForegroundColor Green
            Write-host "Microsoft Windows Licence has been Activated" -ForegroundColor Cyan } 
        else 
        
        { 
            Write-Host  "Error : " -NoNewline -ForegroundColor red
            Write-host "Microsoft Windows Licence has Not Activated" 
            slui.exe 3
            pause
        }
