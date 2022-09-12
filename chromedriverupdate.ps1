
<#
Här finns filen vi vill ha
https://chromedriver.storage.googleapis.com/VERSION/chromedriver_win32.zip
TODO:
@done - Hitta vilken fil vi skall ha
@done - ladda ner fil
@done - Meddela teams/mail/larm vad vi gjort
@done packa upp fil
@done flytta fil till rätt ställe
@done - check för att se violken version vi är på?
@done - spara releasenotes
@done Teams kanal: 
#>
$logfile = ".\ChromeDriver.txt"
$TeamsID = 'webhook url'
$localchrome = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo | Select -ExpandProperty 'ProductVersion'

$version = Invoke-WebRequest 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' | Select -ExpandProperty 'Content'

if ($localchrome.SubString(0, 2) -eq $version.SubString(0, 2)) {
    Write-output "---------------------------" | Out-File -FilePath $logfile -Append
    $date = Get-Date
    $date -f "MMddyy HH:mm" | Out-File -FilePath $logfile -Append 
    $output = "Major Version is the same $version" | Out-File -FilePath $logfile -Append
}
else {
    Write-output "New Majorversion detected, initiating a download"
    Write-output "---------------------------" | Out-File -FilePath $logfile -Append
    $output = "New Majorversion detected $version" | Out-File -FilePath $logfile -Append
    $releasenotes = Invoke-WebRequest -uri "https://chromedriver.storage.googleapis.com/$version/notes.txt" | Select -ExpandProperty 'Content' | Out-File -FilePath $logfile -Append
    $dir = "\bin\"
    mkdir $dir\$version
    $releasenotes | Out-File "$dir\$version\releasenotes.txt"

    $downloadpath = "https://chromedriver.storage.googleapis.com/" + "$version" + "/chromedriver_win32.zip"
    Invoke-WebRequest -uri $downloadpath  -OutFile $dir\$version\chromedriver_win32.zip
    Send-TeamsMessage {
        New-TeamsSection {
            ActivityTitle -Title "**Ny Chromedriver**"
            ActivitySubtitle -Subtitle "Ny Chromedriver har laddats ner med versionsnummer: $version"
            ActivityText -Text "downloaded chromedriver"
        }
    } -Uri $TeamsID -Color DarkSeaGreen -MessageSummary 'status'
}
