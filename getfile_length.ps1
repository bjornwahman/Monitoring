param(
[string]$folderpath = "C:\Temp\testar\",
[string]$filefilter = "*.txt",
[int]$threshold = 1   #threshold i sekunder
)

[int]$currentHour = (get-date).Hour

if ($folderpath -eq "") {
    Write-Host "Please specify -folderpath [C:/bla/bla/bla]"
    exit 3
}


$statuscode = 0
$statusOutput = "OK: All $filefilter files in $folderpath\ is within threshold of $threshold seconds"

#Vi tvingar powershell till array
$filesWithError = @()

    #Hämta filer i foldern, sorterat på LastWriteTime (nyaste först)
    $fileObjects = Get-ChildItem -Path $folderpath -Recurse | Where-Object -FilterScript { $_ -like $filefilter} | Sort-Object -Property LastWriteTime -Descending

    #Om äldre än threshold, stoppar vi in den i en array
$fileObjects | ForEach-Object {
    
    if($_.LastWriteTime -lt ((get-date).AddSeconds(-$threshold))){
        [array]$filesWithError += $_.FullName
    
    }  
}


#Om array inte är tom har vi errors
if($filesWithError -ne $null){
#statuscode 2 som opsview vill ha för att veta severity
   $statuscode=2
#Vi bakar ihop array till en string
   $filesWithErrorString = '"{0}"' -f ($filesWithError -join '" \ n "')
#vi bygger en statusoutput med datat vi samlat in 
   $statusOutput = "CRITICAL: Files older than $threshold seconds: $filesWithErrorString"
#om string har mer än 1000 tecken så kapar vi bort allt över 1000 tecken.
   if ($statusOutput.Length -gt 1000 ) {$statusOutput = $statusOutput.SubString(0,1000)}

}

Write-Host $statusOutput
exit $statuscode 