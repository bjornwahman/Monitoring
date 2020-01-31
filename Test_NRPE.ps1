$rows = Get-Content hosts.txt

$sucess = foreach ($row in $rows) {
($data = Test-NetConnection -ComputerName $row -Port 5666 -InformationLevel Quiet)
Write-host $row - $data
}