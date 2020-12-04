$servers = Get-Content "web.txt"
$array = @()
$err = @()
$sucess = foreach ($s in $servers) {
    Write-Host "Testing $s"
    $array += "Testing $s " 
    try { $alive = Invoke-WebRequest -Uri $s }
    catch { 
    $err += "$s, An error occurred:"
    Write-Host $_ -ForegroundColor Red
     }
    $status = $alive.StatusCode
    $hostname = $alive.StatusDescription
    Write-Host "Result, $status, $hostname" -ForegroundColor Green
    $array += "Result, $status, $hostname"
}
