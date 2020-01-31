$item = Get-Service -Name "AppReadiness" | Select-Object -Property Status

#Write-Host $item

$statuscode = 0
$statusOutput = "OK: todeloo $item"

$statusobject    
    if($item.Status -ne "Running"){
    $statuscode=2
    $statusOutput = "Service error $item"
}

Write-Host $statusOutput

exit $statuscode