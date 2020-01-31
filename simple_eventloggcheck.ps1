param(
[string]$log = "System",
[string]$source = "Tcpip",
[string]$message = "index 8"
)
$event = @()
$event = Get-EventLog -LogName $log -EntryType Error -Source $source -Message *$message* | Select -ExpandProperty Message
#$eventerror = $event | out-string
$eventerror = [system.String]::Join(" , ", $event)
    if ($event -ne $null)
    {
    $statuscode=2
    Write-Host "CRITICAL: there is errors in ya eventlogg man, $eventerror"
    }
    else 
    {
    Write-Host "OK: all is well in monitoring town, grab a cofee and relax"
    $statuscode=0
    
    }
exit $statuscode 
