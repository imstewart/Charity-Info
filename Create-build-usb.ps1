<#
  .SYNOPSIS
  Creates a Build USB drive to allow dual boot Legeucy and UEFI
  Process
     1. Check if script is being run as Administrator
     2. Checks the what USB drives are atteched, If more that 1 Stops to protect user for wiping wrong drive
     3. Creates $USB Varaible from USB drive attached
     4. List Drive to be wiped 
     5. If Drive Partition is GPT Exit
     6. Gives the User a warning to allow them to cancel
     7. Cleans USB drive of all Partitions
     8. Creates first partition - 1.5GB 
     9. Sets first partition as Active partition
    10. Formats first partition - FAT32 to allow dual boot
    11. Defines first partition as drive E:
    12. Creates second partition: using all of the rest of the available drive 
    13. Formats second partition - NTFS to allow large files and volumes
    14. Defines second partition as drive F:
    15. Copies all the contents of the Image Boot volumes to E:
    16. Copies the TT Build WIM to F:

    Revision History:

    1.0 Initial Release 16/9/24 - Ian Stewart

    #>
    [CmdletBinding()]
    param (
      # PUT PARAMETER DEFINITIONS HERE AND DELETE THIS COMMENT.
    )
    
    process {
    
        if(-not (Test-Administrator))
    {
        # TODO: define proper exit codes for the given errors 
        Write-Error "This script must be executed as Administrator.";
        exit 1;
    }
    
        $USB = get-disk | Select-Object Number,Model,Size,BusType | Where-Object BusType -eq "USB"
    
        if ($USB.count -ge 1) 
            { 
                Write-host "Found more that 1 USB drive atteched, this is too riskly to continue, unplug any other drive and rerun!" 
                exit 1
            }
    
            Clear-Host

            $USB = get-disk | Select-Object * | Where-Object BusType -eq "USB"
            
            write-host "List Current Drive to be wiped:"
            write-host "-------------------------------"
            write-host "Name / Size     : "-NoNewline -ForegroundColor Cyan
            write-host ($USB.FriendlyName  + " : ") -NoNewline -ForegroundColor yellow
            write-host ("{0:N0}"-f (($usb.size/1024/1024/1024))) "GB"  
            write-host "Partition Type  : " -NoNewline -ForegroundColor Cyan
            write-host $usb.PartitionStyle -ForegroundColor yellow
            write-host "Partition State : " -NoNewline -ForegroundColor Cyan
            write-host $usb.healthstatus -ForegroundColor Yellow
            write-host " "

        if ($usb.PartitionStyle -eq "GPT") 
          { 
            Write-host "Error: Drive partition is not MBR, Manual convert to MBR, Using DISKPART" -ForegroundColor Red
            Exit 1
          }
        
        $ans = Read-Host -Prompt "Confirm this is correct Drive that you wish to write to?"  
    
        if ($ans.ToUpper() -NE "Y") { Exit 1 }
    
        $result = get-disk -Number $USB.number  |  Clear-Disk -RemoveData -RemoveOEM
        
        $result = initialize-disk -Number $USB.number  -PartitionStyle MBR -ErrorAction SilentlyContinue
    
        $result = New-Partition -DiskNumber $USB.number -Size 1512mb
    
        $result = Get-Partition -DiskNumber $USB.number -PartitionNumber 1 | Format-Volume -FileSystem FAT32 -NewFileSystemLabel Boot
    
        $result = Set-Partition -DiskNumber $USB.number -PartitionNumber 1 -NewDriveLetter E
    
        $result = Set-Partition -DriveLetter E -IsActive $true
    
        $result = New-Partition -DiskNumber $USB.number -UseMaximumSize
    
        $result = Get-Partition -DiskNumber $USB.number -PartitionNumber 2 | Format-Volume -FileSystem NTFS -NewFileSystemLabel Images
    
        $result = Set-Partition -DiskNumber $USB.number -PartitionNumber 2 -NewDriveLetter F
    
        $boot_source = "c:\images\*"
    
        $boot_dest = "e:\"
    
        Copy-Item -Path $boot_source -Destination $boot_dest -Recurse -verbose
    
        $image_source = "c:\images-wimfiles\*"
    
        $boot_dest = "f:\"
    
        Copy-Item -Path $image_source -Destination $images_dest -Recurse -verbose
    
    
    }
    
    begin {
      # DEFINE FUNCTIONS HERE AND DELETE THIS COMMENT.
      function Test-Administrator  
    {  
        [OutputType([bool])]
        param()
        process {
            [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
            return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
        }
    }
    
    $ErrorActionPreference = "Stop";
    
      $InformationPreference = 'Continue'
      # $VerbosePreference = 'Continue' # Uncomment this line if you want to see verbose messages.
    
      # Log all script output to a file for easy reference later if needed.
      [string] $lastRunLogFilePath = "$PSCommandPath.LastRun.log"
      Start-Transcript -Path $lastRunLogFilePath
    
      # Display the time that this script started running.
      [DateTime] $startTime = Get-Date
      Write-Information "Starting script at '$($startTime.ToString('u'))'."
    }
    
    end {
      # Display the time that this script finished running, and how long it took to run.
      [DateTime] $finishTime = Get-Date
      [TimeSpan] $elapsedTime = $finishTime - $startTime
      Write-Information "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
    
      Stop-Transcript
    }