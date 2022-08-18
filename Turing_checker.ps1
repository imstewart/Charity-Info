#Requires -RunAsAdministrator
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$ProgressPreference = "SilentlyContinue"
$status ="Imaged"
$RACHEL ="No"
clear

function Is-Numeric ($Value)
{
    return $Value -match "^[\d\.]+$"
}
 

# Collect Computer Infomration
    Write-Host  "Info  : " -NoNewline -ForegroundColor Green
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

         Write-Host  "Info  : " -NoNewline -ForegroundColor Green
    
        if (($assetid = Read-Host "Enter Turing asset ID: [$($defaultValue)]") -eq '') {$assetid  = $defaultValue} 

        if ((Is-Numeric ($assetid) -ne $true) -and $assetid.Length -ne 8  ) {
             continue
        }
         break
    } while ($true)


# Get Activation Status
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


# Check in Device drivers are missing
    $Missing_devices = Get-WmiObject Win32_PNPEntity | Where-Object{$_.ConfigManagerErrorCode -ne 0} | Select Name, DeviceID
    
    if ($Missing_devices.count -eq 0) { 
        Write-Host  "Info  : " -NoNewline -ForegroundColor Green
        Write-host "Status: All Device drivers installed" } 
    
    else {

# Install Windows Updates
    
            Write-Host "Info  : " -NoNewline -ForegroundColor Green
            Write-host "Checking for any missing device drivers - Please wait..."
            Write-Host "Info  : " -NoNewline -ForegroundColor Green 
            Write-Host "--------------------------------------------------------"

            $res = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            $res = Install-Module -Name PSWindowsUpdate -Force -WarningAction SilentlyContinue
    
            $driver_count = Get-WindowsUpdate -WindowsUpdate -UpdateType Driver

            Write-Host "Info  : " -NoNewline -ForegroundColor Green
            Write-host "List of all device drivers being updated"
            $driver_count.title | sort -Unique
        
            Write-Host "Error : " -NoNewline -ForegroundColor Red          
            write-host "Number of device drivers missing: " -NoNewline -ForegroundColor Green
            write-host $Missing_devices.count -ForegroundColor red

            Write-Host "Info  : " -NoNewline -ForegroundColor Green
            Write-host "Installing missing device drivers and updating any other drivers available - This can take 5 mins." -ForegroundColor Yellow
    
           $drivers = Get-WindowsUpdate -WindowsUpdate -UpdateType Driver -Install -AcceptAll -IgnoreReboot | select Result,size,title

        }


# Check in Device drivers again

    $Missing_devices = Get-WmiObject Win32_PNPEntity | Where-Object{$_.ConfigManagerErrorCode -ne 0} | Select Name, DeviceID
    
    if ($Missing_devices.count -ne 0) 

        {
        
            Write-Host "Error : " -NoNewline -ForegroundColor Red
            Write-host "After initial windows update there are still missing, may require a reboot to clear" 
            devmgmt.msc
        }

pause 

# Collecting Disk Data

    Write-Host "Info  : " -NoNewline -ForegroundColor Green
    Write-host "Collecting Disk Data ..."

    $drives = Get-WMIObject Win32_LogicalDisk | Select DeviceID

# Test if Rachel is installed on any Drive

foreach ($drive in $drives.DeviceID)
{
    if ($RACHEL -ne "Yes") { 
        $testdrive = $drive.tostring() + "\Rachel"

        if ( Test-Path ($testdrive)) { $RACHEL ="Yes"} else  { $RACHEL ="No" }
            Write-Host "Info  : " -NoNewline -ForegroundColor Green
            Write-host "Rachel Installed : " -NoNewline
            Write-host "$RACHEL" -ForegroundColor Yellow

    }
   
}

# Ask if Device is for Sales

    if ( $RACHEL -EQ "Yes" ) 

        {
            Write-Host "Info  : " -NoNewline -ForegroundColor Green
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
    Write-Host "Info  : " -NoNewline -ForegroundColor Green
    Write-host "Exporting computer Info to JSON" 
    $turingdata | convertto-json | Out-File -FilePath $jsonfile
    
# Post data to Web Server
    Write-Host "Info  : " -NoNewline -ForegroundColor Green
    Write-host "Posting computer Info to Server" 
    try
    {
        $request = Invoke-WebRequest -Uri http://192.168.0.1:8000/ws/blancco.html  -Method 'Post' -Body $jsonfile -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        Write-Host "Info  : " -NoNewline -ForegroundColor Green
        write-host "Data was sent to Server."
    }
    catch 
    {
        Write-Host "Error :" -NoNewline -BackgroundColor red
        write-host " Data NOT sent to Server." -ForegroundColor Red
    }


# Test default Applications
    Write-Host  "Info  : " -NoNewline -ForegroundColor Green
    Write-host "Testing Turing Trust Apps" -ForegroundColor Yellow
    Write-Host  "Check : " -NoNewline -ForegroundColor Green
    Write-host "1. LibreOffice"
    Start-Process -Wait "C:\Program Files\LibreOffice\program\soffice.exe"
    Write-Host  "Check : " -NoNewline -ForegroundColor Green
    Write-host "2. Rapid Typing"
    Start-Process -Wait "C:\RapidTyping\RapidTyping.exe"
    Write-Host  "Check : " -NoNewline -ForegroundColor Green
    Write-host "3. Scratch"
    Start-Process -wait "C:\Users\user1\AppData\Local\Programs\Scratch 3\Scratch 3.exe"
    Write-Host  "Check : " -NoNewline -ForegroundColor Green
    Write-host "4. Rachel video and sound"
    Start-Process -wait "chrome.exe" "file:///C:/RACHEL/RACHEL/modules/khan_academy/math/arithmetic/addition-subtraction/basic_addition/basic-addition.html"
    Write-Host  "Check : " -NoNewline -ForegroundColor Green
    Write-host "6. View PDF Document"
    Start-Process -wait "chrome.exe" "file:///C:/Users/Public/Documents/Computer%20studies%20syllabus%20and%20past%20papers/Malawi-msce-computer-studies-syllabus-2001_Forms%201and2.pdf"
    Write-Host  "Check : " -NoNewline -ForegroundColor Green
    Write-host "7. Check Security Dashboard is copascetic"
    Start-Process WindowsDefender:

# Cleanup Shortcut File
    remove-item -Path "C:\Users\user1\Desktop\Turing Checker Script.lnk" -Force

# End of Checks
    Write-Host  "Info  : " -NoNewline -ForegroundColor Green
    Write-host "Please stick a purple dot to the device" -ForegroundColor Yellow

    Write-Host
    write-host "All checks completed - Press to close.." -ForegroundColor Cyan
    read-host

# List Export JSOn File : For testing only
#gc("c:\temp\post_data.json")
