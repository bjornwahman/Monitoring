# eventlog check 2020-01-31 Björn Wahman
# Reference:
# Get-EventLog -LogName Application -Source Outlook | Where-Object {$_.EventID -eq 63} | Select-Object -Property Source, EventID, InstanceId, Message
#
param(
[string]$log = "System",
[string]$source = "Tcpip",
[string]$message = "index 8"
)
$event = @()
$event = Get-EventLog -LogName $log -EntryType Error -Source $source -Message *$message* | Select -ExpandProperty Message
#$eventerror = $event | out-string
#$eventerror = [system.String]::Join(" | ", $event)
    if ($event -ne $null)
    {
    $eventerror = [system.String]::Join(" | ", $event)
    $statuscode=2
    Write-Host "CRITICAL: there is errors in the log $log, $eventerror"
    }
    else 
    {
    Write-Host "OK: all is well in monitoring town, grab a covfefe and relax"
    $statuscode=0
    
    }
exit $statuscode 
