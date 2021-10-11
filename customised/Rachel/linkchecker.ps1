
$files = New-Object System.Collections.ArrayList

$brokenlinks = New-Object System.Collections.ArrayList

$indexfile = gc("C:\RACHEL\RACHEL\index.html") | sort -Unique

foreach ($items in $indexfile)
{
    if($items -like "*a href*" ) { #Write-Host $item.Split('"')[1]

        if ($items -notlike "*pdf*" ) {

            $line = $items.Split('"')[1]

                $temp = New-Object System.Object
            
                    $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value $line
    
                $files.Add($temp) | Out-Null


            }
    }

}


$files = $files.name | sort -Unique
cls
#$files


#$files = Get-Content("D:\RACHEL\rachellinks.txt")

foreach ($file in $files) {

    $file = $file.Split("#")[0]

    #Write-Host "Checking file" $file

    if (test-path $file.replace("%20", " ").replace("%25","%")) {

        $index = Get-Content($file.replace("%20", " ").replace("%25","%"))
        
        $filename = Get-ChildItem $file.replace("%20", " ").replace("%25","%")

        #write-host $filename

        foreach ($item in $index)
        {
                    
            if ($ITEM -like "*href*") 
            { 
            
                $data = $item.Split('"') 
                
                foreach ($html in $data) 
                {

                    if ($html -like "*.htm*") 
                    { 

                        $check = $html.Split("#")[0]
                        #$check

                        $shortfile = $null

                        if ($check.Substring(0, 3) -eq "../") 
                            {
                                $check = $check.Substring(3, ($check.Length - 3))
                               # $check

                                $shortfile = $filename.directory.ToString()
                                $length = $shortfile.LastIndexOf("\")
                                        
                                $checkshort = $shortfile.substring(0, $length)
                                    
                            }
                        else {

                            #$check

                            if ($check.Substring(0, 2) -eq "./") { $check = $check.Substring(2, ($check.Length - 2)) }

                            }
                            
                            
                        #if ($check.Substring(0,5) -eq "../..") { $check = $check.Substring(5,($check.Length-5)) }


                            if ($null -eq $shortfile) { $check = $filename.Directoryname.ToString() + "\" + $check }
                            else {
                                $check = $checkshort + "\" + $check

                            }
                        


                       # $check = $check.replace("#32;", " ")
                      
                        if (Test-Path -literalpath $check.replace("%20", " ").replace("%25","%"))
                    
                        {  } 
                    
                        else 
                            
                        { if ($filename.fullname.length -ge 195){Write-host "..."("{0,-76}" -f $filename.fullname.Substring($filename.fullname.Length - 72)) -NoNewline  -ForegroundColor Green} else {Write-host ("{0,-125}" -f $filename) -NoNewline  -ForegroundColor Green}
                          write-host " : " -NoNewline
                          write-host ("{0,-70}" -f ($html)) -ForegroundColor Yellow
                          
                                        $temp = New-Object System.Object
            
                                                $temp | Add-Member -MemberType NoteProperty -Name "IndexName" -Value $filename.fullname
                                                $temp | Add-Member -MemberType NoteProperty -Name "link" -Value $html
    
                                        $brokenlinks.Add($temp) | Out-Null

                                        if ($Check -like "*series*") { pause}
                          
                          }
                        
                        #  if ($html.Length -ge 39){write-host ("{0,-30}" -f ($html.Substring($html.Length - 40))) -NoNewline -ForegroundColor Yellow} else {write-host ("{0,-40}" -f ($html)) -NoNewline -ForegroundColor Yellow}
                        #  write-host " : " -NoNewline 
                        #  write-host " Missing file "  -NoNewline -ForegroundColor Green
                        #  write-host $check  -ForegroundColor Red }
                    


                        #Write-Host $check


    



                    }
                }
            }
            
        }
    }
    else {
        Write-host "Index file missing: " $file
    }
    
}