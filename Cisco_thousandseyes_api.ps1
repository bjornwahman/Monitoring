$token = "SECRET TOKEN"

$headers = @{
    authorization = "Bearer $token"
}
$ContentType = "application/json"

$checks = Invoke-RestMethod -Uri "https://api.thousandeyes.com/v6/tests.json" -Method GET -Headers $headers -ContentType $ContentType

$checkid = $checks.test | where { $_.description -eq "scom" } | Select-object testId

foreach ($check in $checkid.testId) {

    $response = @()

    $checkurl = "https://api.thousandeyes.com/v6/web/http-server/" + "$check" + ".json"

    $checkdata = Invoke-RestMethod -Uri $checkurl -Method GET -Headers $headers -ContentType $ContentType

    $response = $checkdata.web.httpServer.responseCode | Select-object -Last 1


    if ($response -eq 200) {
        $Output = "OK, HTTP Statuscode is: $response"
        Write-Output $Output
    }   
    if ($response -eq 0) {
        $errordetails = $checkdata.web.httpServer.errorDetails | Select-object -Last 1
        $Output = "CRITICAL, HTTP Statuscode is: $response, $errordetails"
        Write-Output $Output
    }   
}
