#Temperature on Cryptoserver
#Bjorn Wahman 2020-02-05
#Install-Module -Name Proxx.SNMP 

$Temperature = Invoke-SnmpGet -IpAddress 1.1.1.1 -Community "public" -Version Ver2 -Oid ".1.3.6.1.4.1.3159.1.2.1.6.1"
$myoutput = $Temperature.Value

#$myoutput = 95

if ($myoutput -ge 60) {
    $statuscode=2
    Write-Host "CRITICAL: The temperature is $myoutput °C"
    }
    ElseIf
    ($myoutput -ge 50) {
    $statuscode=2
    Write-Host "WARNING: The temperature is $myoutput °C"
    }
    else
    {
    Write-Host "OK: all is well in opsview town"
    $statuscode=0
    }
