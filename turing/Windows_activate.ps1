function get-licencekey {

    # Check to see if the desktop has an activated licence
    write-host "Checking Windows activation status : " -NoNewline
    $activated = Get-activation_status
    Write-Host $activated -ForegroundColor yellow
    
    # Get the Windows version 
    $licencetype = Get-WmiObject -Class Win32_OperatingSystem | Select-Object Caption
    Write-host "Current Version installed          : " -NoNewline
    Write-Host $licencetype.caption -ForegroundColor Yellow

    #

    $results=$null
        
    # If licence is required loop
    if (!$activated)
        {
    
            write-host "Does computer have a Windows 7 licence key label?" -NoNewline -ForegroundColor Cyan
            write-host " [y/n] " -NoNewline -ForegroundColor green
            $answer = read-host 

            while("y","n","Y","N" -notcontains $answer)
            {
                write-host "Does computer have a Windows 7 licence key label?" -NoNewline -ForegroundColor Cyan
                write-host " [y/n]" -NoNewline -ForegroundColor green
                $answer = Read-Host
            }
            
                if ($answer.tolower() -eq "y") 
                    {
                        Write-host "Please enter licence key in activation window." -ForegroundColor green
                        $process = get-process SystemSettingsAdminFlows -ErrorAction SilentlyContinue
                        if (!$process) 
                                {
                                    # Launch Activation process
                                    slui 3
                                 }
                       :loop while (!$activated)
                                    {
                                        $activated = Get-activation_status
                                        Start-Sleep -Seconds 10
                                        write-host "Waiting for licence to be activated " -ForegroundColor Green -NoNewline
                                        write-host "....."  -ForegroundColor Yellow
                                        #break loop
                                        
                                    }
                   
                        $results = "Windows Licence now activated"
                           
                    }
                else 
                    {
                        if ($licencetype.caption -eq "Microsoft Windows 10 Pro" ) {$url = "https://tt-license-server.onrender.com/license/request/pro"}
                        if ($licencetype.caption -eq "Microsoft Windows 10 Home" ) {$url = "https://tt-license-server.onrender.com/license/request"}
            
                        # Get Licence Key
                        Try  {
                                    $licences = Invoke-RestMethod -Uri $URL 
                                } 
                            Catch 
                                {
                                    if($_.ErrorDetails.Message) {
                                        Write-Host $_.ErrorDetails.Message
                                    Exit
                                    } 
                                }

                        # copies licence to clipboard
                        Set-Clipboard $licences.key
                        Write-Host "Licence key is now in clipboard    : " -NoNewline
                        write-host $licences.key -ForegroundColor Yellow

                        $process = get-process SystemSettingsAdminFlows -ErrorAction SilentlyContinue

                            if (!$process) 
                                    {
                                        # Launch Activation process
                                        slui 3
                                        while (!$activated)
                                        {
                                            $activated = Get-activation_status
                                            Install-Key
                                        }
                                    }
                            else {
                                    while (!$activated)
                                        {
                                            $activated = Get-activation_status
                                            Install-Key
                                        }
                                  }
                    }
            }

    
        if ($activated) {    $results = "Windows Licence activated" }
  
    
    Write-Host "Results : " -NoNewline -ForegroundColor Green
    Write-Host $results -ForegroundColor Yellow
    return $results
    
    }
    
function Get-activation_status {
        # check Windows activation staus
        $Activation_status = Get-CIMInstance -query "select Name, Description, LicenseStatus from SoftwareLicensingProduct where LicenseStatus=1" | Select-Object LicenseStatus
        if ($Activation_status.LicenseStatus -eq 1) {
  
                $Activation_status_code = $True
            } 
            else 
            
            { 
               # Write-Host  "Error : " -NoNewline -ForegroundColor red
               # Write-host "Microsoft Windows Licence has Not Activated" 
                $Activation_status_code = $False
            }
        # 

        
        return $Activation_status_code 
        
    }

function Install-Key{
        if ($licencetype.caption -eq "Microsoft Windows 10 Pro" ) {$url = "https://tt-license-server.onrender.com/license/request/pro"}
        if ($licencetype.caption -eq "Microsoft Windows 10 Home" ) {$url = "https://tt-license-server.onrender.com/license/request"}
        
        $answer =$null

        while("y","n","Y","N" -notcontains $answer)
        {
            write-host "Did the licence key work?" -NoNewline -ForegroundColor Cyan
            write-host " [y/n] ...: " -NoNewline -ForegroundColor green
            $answer = Read-Host 
        }
        if ($answer.tolower() -eq "y") 
            {
                $url_reply = "https://tt-license-server.onrender.com/license/keys/"+$licences.key+"?success=true"
                Invoke-RestMethod $url_reply -Method PUT
            }
        else 
            {
                $url_reply = "https://tt-license-server.onrender.com/license/keys/"+$licences.key+"?success=false"
                Invoke-RestMethod  $url_reply -Method PUT
                Try  {
                    $licences = Invoke-RestMethod -Uri $URL
                    Set-Clipboard $licences.key
                    Write-Host "Licence key is now in clipboard    : " -NoNewline
                    write-host $licences.key -ForegroundColor Yellow
                } 
                Catch 
                    {
                        if($_.ErrorDetails.Message) {
                            Write-Host $_.ErrorDetails.Message
                        Exit
                        } 
                    }
            }
    }

# Main script
$test = get-licencekey
