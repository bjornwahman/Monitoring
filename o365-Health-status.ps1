##############################################
# Api frågor emot test tenent i 0365, bjornwahman.onmicrosoft.com
# 
#
#################

# Info om tenent, All denna data finns på azure ad admin sidan i din tenent
# Install-Module PSWinDocumentation.O365HealthService -Force
$ApplicationID = 'secret'
$ApplicationKey = 'secret'
$TenantDomain = 'secret' 

# ------------------------------------------------------

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -ToLocalTime -Verbose
$O365.CurrentStatus | Format-Table -AutoSize

$okservice = $O365.CurrentStatus -Match "Normal service"
$errorservice = $O365.CurrentStatus -notMatch "Normal service"

if ($errorservice.count -gt 0){
    $StatusOutput = "Some 0365 services is not in a normal state: "
    $errorservice.Service | ForEach-Object {
    $statusOutput = $statusOutput + $_ + ", "
}
    $statusOutput = $statusOutput.TrimEnd(", ")
    Write-Host $statusOutput
}
else
{
    $OKstatus = "All services reported normal status"
    
    Write-Host "$OKstatus"

}
