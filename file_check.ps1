param(

[string]$folderpath = "C:\tmp\test",
[string]$filefilter = "*.xml"

)

[int]$currentHour = (get-date).Hour

if ($folderpath -eq "") {
    Write-Host "Please specify -folderpath [C:/bla/bla/bla]"
    exit 3
}

##threshold är i utgångsläget 10 minuter
[int]$threshold = 600

##Om klockan är mellan 7 och 16 sätter vi threshold 2 timmar
#if (($currentHour -gt 7) -and ($currentHour -lt 16)){
#[int]$threshold = 600
#}

##Fast om klockan är mellan 11 och 12 ändrar vi til 1 timme
#if (($currentHour -gt 11) -and ($currentHour -lt 12)){
#[int]$threshold = 600
#}

##Och är den mellan 16 och 21 är threshold 5 timmar
#if (($currentHour -gt 16) -and ($currentHour -lt 21)){
#[int]$threshold = 600
#}



$statuscode = 0
$statusOutput = "OK: Newest file is within threshold"

$filesWithError = @()

    #Hämta filer i foldern, sorterat på LastWriteTime (nyaste först)
    $fileObjects = Get-ChildItem -Path $folderpath | Where-Object -FilterScript { $_ -like $filefilter} | Sort-Object -Property LastWriteTime -Descending

    #Om den nyaste är äldre än threshold, stoppar vi in den i en array
    if($fileObjects[0].LastWriteTime -lt ((get-date).AddSeconds(-$threshold))){
    $filesWithError += $fileObjects[0].Name
    
    
    }



#Om array inte är tom har vi error på nyaste filen
if($filesWithError -ne $null){
   $statuscode=2
   $statusOutput = "CRITICAL: Newest file in $folderpath is older than $threshold seconds: $filesWithError"

}

Write-Host $statusOutput
exit $statuscode 
