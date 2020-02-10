param(
[string]$file = "C:\tmp\test\agresso.txt",
[string]$textstring1 = "ORA-1",
[string]$textstring2 = "911"
)

$fileobjects = @()
    $fileobjects = Get-Content $file | Where-Object {$_ -match 'ORA-1.+.911'}
    if ($fileobjects -ne $null)
    {
    $statuscode=2
    Write-Host "CRITICAL: $fileobjects"
    }
    else 
    {
    Write-Host "OK: all is well"
    $statuscode=0
    
    }
exit $statuscode
