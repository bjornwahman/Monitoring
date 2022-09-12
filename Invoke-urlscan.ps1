<#Funktion för att testa vilket värde en sida får på urlscan.io samt ge en länk till screenshot av din scannade sida
Author: Björn Wahman 2022
Scriptet tar en inparameter som är den url som du vill testa
./Invoke-urlscan www.sunet.se
#>
function Invoke-urlscan{ 

    [CmdletBinding()]
    param (    
    
        [string]$QueryUrl = "www.sunet.se"
        
    )  
    $urlscan = Invoke-RestMethod -uri "https://urlscan.io/api/v1/search/?q=domain:$QueryUrl"
    $scanresult = $urlscan.results.result | select-object -First 1
    $scanimage = $urlscan.results.screenshot | select-object -First 1
    $gbgurlscan = Invoke-RestMethod -uri $scanresult
    $finalresult = $gbgurlscan.verdicts.overall
    Write-host "---------------------"
    Write-host "Website: $QueryUrl`nScore: $($finalresult.score)`nMalicious: $($finalresult.malicious)`nScreenshot: $scanimage"
    Write-host "---------------------"

}
