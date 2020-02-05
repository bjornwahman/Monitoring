#Install-Module -Name Proxx.SNMP 
$Temperature = Invoke-SnmpGet -IpAddress 1.1.1.1 -Community "public" -Version Ver2 -Oid ".1.3.6.1.4.1.3159.1.2.1.6"
$myoutput = $Temperature.Value

$myoutput = $myoutput | Where-Object -FilterScript {$myoutput -ge 98}
if ($myoutput -ne $null)
 {
    $statuscode=2
    Write-Host "The temperature is $myoutput °C"
    }
    else 
    {
    Write-Host "OK: all is nice and cozy here"
    $statuscode=0
    
    }