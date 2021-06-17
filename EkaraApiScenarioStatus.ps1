<# 
    Ekara API 

    Björn Wahman 2021-02-23
    version 0.1
    Göteborgs Stad
    Testar checkID i en loop av alla ids vi anger även tidpunkt, den verkar vara inställd på 1 timma tillbaka i tiden vilket troligtvis beror på annan tidszon.

#>

# Först bygger vi en token som kan återanvändas i våra anrop.
$body = @{
    email = ""
    password = ""
}
$token = Invoke-RestMethod -Uri 'https://api.ekara.ip-label.net/auth/login' -Method POST -Body $body | Select -ExpandProperty "token"

# Sen autentiserar vi oss med token och hämtar status på alla scenarios
$checks = Invoke-RestMethod -Uri "https://api.ekara.ip-label.net/results-api/scenarios/status" -Method GET -Headers @{
authorization = "Bearer $token"
}

$checkid = $checks | Select-object -ExpandProperty scenarioId

$datefrom = (Get-Date).Addminutes(-75).tostring("yyyy-MM-dd hh:mm:ss")
$dateto = (Get-Date).Addminutes(-60).tostring("yyyy-MM-dd hh:mm:ss")


$body = @{dates = @{from  = "$datefrom";to = "$dateto"}
}
$body = $body | ConvertTo-JSON

$checkstatus = @()
foreach ($id in $checkid){
$Uri = "https://api.ekara.ip-label.net/results-api/availability/$id"
$checks = Invoke-RestMethod -Uri $Uri -ContentType 'application/json' -Method POST -Headers @{
authorization = "Bearer $token"
} -Body $body

$checkstatus += $checks | Select-object scenarioName, rate, details
}
<# Sen kollar vi statuskoderna, nedan är de olika statuskoderna och vad de betyder
1 = OK 
2 = Not Okay (Error)
4 and 5 = no execution planned (maintenance mode)
0 = no measures (all sites busy)
#>
foreach ($check in $checkstatus){
$status = $check.details.status | Select-Object -last 1
$name = $check.scenarioName
if ($status -eq 1) {
    $Output = "OK: $name seems fine, statuscode: $status"
    Write-Output $Output
}
if ($status -eq 2) {
    $Output = "Critical: $name, Not Okay (Error) statuscode: $status"
    Write-Output $Output
}
if ($status -eq 4) {
    $Output = "Warning: $name, no execution planned (maintenance mode) statuscode: $status"
    Write-Output $Output
}
if ($status -eq 5) {
    $Output = "Warning: $name, no execution planned (maintenance mode) statuscode: $status"
    Write-Output $Output
}
if ($status -eq 0) {
    $Output = "Critical: $name, no measures (all sites busy), statuscode: $status"
    Write-Output $Output
}

}
