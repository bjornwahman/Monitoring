# 2020-01-31 Björn Wahman
# Letar efter strings i textfiler och ge statuskoder till opsview beroende på vad den hittar
param(
[string]$file = "C:\trove\log.txt",
[string]$filefilter = "voltage"
)
    $fileobjects = Select-String -Path $file -Pattern "$filefilter"
    if ($fileobjects -ne $null)
    {
    $statuscode=2
    Write-Host "CRITICAL: you are fucked, the string $filefilter has been found, do you have access to your prepping gear? underground bunker is feature complete?"
    }
    else 
    {
    Write-Host "OK: all is well in opsview town"
    $statuscode=0
    
    }
exit $statuscode 