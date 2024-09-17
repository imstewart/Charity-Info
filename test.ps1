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

