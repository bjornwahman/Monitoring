# .ps1 script som körs i en docker container för att uppdatera min home assistant med aktuell bad temperatur.
# Token för Home assistant
$token = "secret"
New-HomeAssistantSession -ip x.x.x.x -port 8123 -token $token
while ($true) {
    $plats = "Onsala"
    #Hämta data om badtemperatur ifrån SMHI
    $data = Invoke-RestMethod -Uri "https://www.smhi.se/wpt-a/backend_observation/ocobsboos/category/seatemperature" -Headers @{
        "method"    = "GET"
        "authority" = "www.smhi.se"
        "scheme"    = "https"
        "accept"    = "application/json, text/javascript, */*; q=0.01"
    }
  
    $stad = $data -match $plats
  
    $temperatur = $stad.values.seatemperature.values.value
    #$temperatur | Out-File /mnt/temp/temperatur.txt
    $output = "Badtemperaturen i Frillesas just nu $temperatur grader"
    #bygger en JSON med temperaturen för att Home Assistant skall kunna tolka datat
    $json = '{"variable":"bad_vatten_temperatur","value":' + '"' + "$temperatur" + '"' + '}'
    #Uppdaterar home assistant med senaste temperatur.
    Invoke-HomeAssistantService -service variable.set_variable -json $json
    Write-Output $output
    #Vilar i en timma då vi inte behöver mer granulär data.
    Start-Sleep -s 3600
}
