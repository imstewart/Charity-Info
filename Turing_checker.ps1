#Requires -RunAsAdministrator
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$ProgressPreference = "SilentlyContinue"
$status ="Imaged"
$RACHEL ="No"

function Is-Numeric ($Value)
{
    return $Value -match "^[\d\.]+$"
}
 

# Collect Computer Infomration
    Write-host "Collecting Computer Info" -ForegroundColor Yellow
    $computerinfo = Get-ComputerInfo

# Check in the device has an Asset Number
    $webrequest =  "http://pi.ianstewart.net/"+$computerinfo.BiosSeralNumber+".ser"

    try
    {
        $Response = Invoke-WebRequest -Uri $webrequest -UseBasicParsing

        # This will only execute if the Invoke-WebRequest is successful.
        $StatusCode = $Response.StatusCode

        $webclient = new-object System.Net.WebClient
        
        $webpage = $webclient.DownloadString($webrequest)
    }
catch
{
    $StatusCode = $_.Exception.Response.StatusCode.value__


}

    # Get Assset Number
    do {
         $defaultValue = $webpage.TrimEnd()
    
        if (($assetid = Read-Host "Press Turing asset ID:") -eq '') {$defaultValue} else {$assetid}

        if ((Is-Numeric ($assetid) -ne $true) -and $assetid.Length -le 7 -or $assetid.Length -ge 9  ) {
             continue
        }
         break
    } while ($true)


 


# Get Activation Status
    $Activation_status = Get-CIMInstance -query "select Name, Description, LicenseStatus from SoftwareLicensingProduct where LicenseStatus=1" | select LicenseStatus
    if ($Activation_status.LicenseStatus -eq 1) { Write-host "    Status: Windows Licence Activated" -ForegroundColor Green } 
    else 
    { Write-host "    Status: Windows Licence Not Activated" -ForegroundColor Red 
      slui.exe 3
      pause
    }


# Check in Device drivers are missing
    $Missing_devices = Get-WmiObject Win32_PNPEntity | Where-Object{$_.ConfigManagerErrorCode -ne 0} | Select Name, DeviceID
    
    if ($Missing_devices.count -eq 0) { Write-host "    Status: All Device drivers installed" -ForegroundColor Green} 
    
    else {

            write-host " Number of device drivers missing: " -NoNewline -ForegroundColor Green
            write-host $Missing_devices.name -ForegroundColor Yellow


# Install Windows Updates
    
            Write-host "Checking for any missing device drivers" -ForegroundColor Yellow
            $res = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            $res = Install-Module -Name PSWindowsUpdate -Force -WarningAction SilentlyContinue
    
            $driver_count = Get-WindowsUpdate -WindowsUpdate -UpdateType Driver
        
            write-host " Number of device drivers missing: " -NoNewline -ForegroundColor Green
            write-host $Missing_devices.name -ForegroundColor Yellow
    
        Get-WindowsUpdate -WindowsUpdate -UpdateType Driver -Install -AcceptAll -IgnoreReboot | select Result,size,title
        
        Write-host "Installing missing device drivers" -ForegroundColor Yellow

        }


# Check in Device drivers again

    $Missing_devices = Get-WmiObject Win32_PNPEntity | Where-Object{$_.ConfigManagerErrorCode -ne 0} | Select Name, DeviceID
    
    if ($Missing_devices.count -ne 0) 

        {
        
            Write-host " Status: After initial windows update there are still missing, may require a reboot to clear" -ForegroundColor Red 
            pause 
        }


# Collecting Disk Data

    Write-host "Collecting Disk Data ..." -ForegroundColor Yellow

    $drives = Get-WMIObject Win32_LogicalDisk | Select DeviceID

# Test if Rachel is installed on any Drive

foreach ($drive in $drives.DeviceID)
{
    if ($RACHEL -ne "Yes") { 
        $testdrive = $drive.tostring() + "\Rachel"

        if ( Test-Path ($testdrive)) { $RACHEL ="Yes"} else  { $RACHEL ="No" }
            Write-host "Rachel Installed : " -NoNewline
            Write-host " $RACHEL" -ForegroundColor Yellow

    }
   
}

# Ask if Device is for Sales

    if ( $RACHEL -EQ "Yes" ) 

        {

            $forSale = Read-Host "ForSale? y/[N] "

                If (!$forSale) { $forSale = 'No'}
                if ( $forSale.ToUpper() = "N") {$forSale = 'No'}

        }

    else 

        {

            $forSale = Read-Host "ForSale? [Y]/n "
                If (!$forSale) {$forSale = 'Yes'}
                if ( $forSale.ToUpper() = "Y") {$forSale = 'Yes'}

        }


# Create Data object for Exporting
    $turingdata = (New-Object PSObject |
  
       Add-Member -PassThru NoteProperty assetid $assetid |
       Add-Member -PassThru NoteProperty forSale $forSale | 
       Add-Member -PassThru NoteProperty RACHEL $RACHEL | 
       Add-Member -PassThru NoteProperty status $status |
       Add-Member -PassThru NoteProperty installDate ($computerinfo.OsInstallDate).tostring("yyyyMMddHHmmss.000000+000")  |
       Add-Member -PassThru NoteProperty memoryTotal $computerinfo.CsPhyicallyInstalledMemory.ToString() |
       Add-Member -PassThru NoteProperty os $computerinfo.OsName |
       Add-Member -PassThru NoteProperty osVersion $computerinfo.OsVersion |
       Add-Member -PassThru NoteProperty systemModel $computerinfo.CsModel |
       Add-Member -PassThru NoteProperty systemManufacturer $computerinfo.CsManufacturer|
       Add-Member -PassThru NoteProperty systemSerial $computerinfo.BiosSeralNumber |
       Add-Member -PassThru NoteProperty systemType $computerinfo.CsSystemFamily  |
       Add-Member -PassThru NoteProperty cpuSockets @(($computerinfo.CsProcessors | select name)) |
       Add-Member -PassThru NoteProperty diskinfo @((Get-CimInstance -ClassName Win32_DiskDrive -Property Manufacturer,model,serialnumber,size,Status,Interfacetype | select @{N ="Vendor"; E = {$_.Manufacturer}},model,serialnumber,@{N ="Size"; E = {$_.Size.tostring()}},@{N ="Health"; E = {$_.Status}},Interfacetype))
    )


# Convert Data to JSON
    $jsonfile  = "c:\temp\post_data.json" 
    Write-host "Exporting computer Info to JSON" -ForegroundColor Yellow
    $turingdata | convertto-json | Out-File -FilePath $jsonfile
    
# Post data to Web Server
    Write-host "Posting computer Info to Server" -ForegroundColor Yellow
    Invoke-WebRequest -Uri http://192.168.0.1:8000/ws/blancco.html  -Method 'Post' -Body $jsonfile



# Test default Applications
    Write-host "Testing Turing Trust Apps" -ForegroundColor Yellow
    Write-host "1. LibreOffice"
    Start-Process -Wait "C:\Program Files\LibreOffice\program\soffice.exe"
    Write-host "2. Rapid Typing"
    Start-Process -Wait "C:\RapidTyping\RapidTyping.exe"
    Write-host "3. Scratch"
    Start-Process -wait "C:\Users\user1\AppData\Local\Programs\Scratch 3\Scratch 3.exe"
    Write-host "4. Rachel video and sound"
    Start-Process -wait "chrome.exe" "file:///C:/RACHEL/RACHEL/modules/khan_academy/math/arithmetic/addition-subtraction/basic_addition/basic-addition.html"
    Write-host "6. View PDF Document"
    Invoke-Item "C:\Users\Public\Documents\Computer studies syllabus and past papers\Malawi-msce-computer-studies-syllabus-2001_Forms 1and2.pdf" 
    Write-host "7. Check Security Dashboard is copascetic"
    Start-Process WindowsDefender:

# End of Checks
read-host "All checks completed - Press to close.." 

# List Export JSOn File : For testing only
#gc("c:\temp\post_data.json")
