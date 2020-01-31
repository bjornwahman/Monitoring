$event = Get-EventLog -LogName System -EntryType Error -Source Tcpip | Select-Object -Property EventID, Message
    if ($event -ne $null)
    {
    $statuscode=2
    Write-Host "CRITICAL: there is errors in ya eventlogg man"
    }
    else 
    {
    Write-Host "OK: all is well in monitoring town, grab a cofee and relax"
    $statuscode=0
    
    }
exit $statuscode 