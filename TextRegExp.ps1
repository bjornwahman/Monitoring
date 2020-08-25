# 2020-08-21 Björn Wahman
# Letar efter strings i textfiler
param(
[string]$file = "C:\Tivoli\Passwordsynch\log\PwdSync.txt",
[string]$textstring = "Starting new thread.  Thread count:",
[string]$threshold = "45"
)

$threadcount = Get-Content "$file"
$threadcount = $threadcount -match "$textstring" | select -Last 1
$data = $threadcount -replace ".*count:"
$match = $data -match "\d*$"
$threadperfdata = $Matches.0

    if ($threadperfdata -gt $threshold)
    {
        Write-Host "CRITICAL: Thread count is over defined threshold ($threshold), there is $threadperfdata running threads"
    }

    else 

    {
        Write-Host "OK: Thread count is within defined threshold ($threshold), there is $threadperfdata running threads"
    }
