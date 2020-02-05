<#
    Author: Joachim Brissman
    Company: Visolit Norway AS
    Date: 27.01.2020
#>
#Install-Module -Name Proxx.SNMP 
#Get Volumes and Utilization with SNMP
$NetappVolumes = Invoke-SnmpWalk -IpAddress 1.1.1.1 -Community "public" -Version Ver2 -Oid ".1.3.6.1.4.1.789.1.5.4.1.2" -TimeOut 160
$NetappUtilization = Invoke-SnmpWalk -IpAddress 1.1.1.1  -Community "public" -Version Ver2 -Oid ".1.3.6.1.4.1.789.1.5.4.1.6" -TimeOut 160
#Smash together Volume and Utilization data
$MyVolumes=@()
$IamHere=-1
foreach ($volume in $NetappVolumes){
    $IamHere++
    $myNewObject = New-Object System.Object
    $myNewObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $volume.value
    $myNewObject | Add-Member -MemberType NoteProperty -Name "Utilization" -Value $NetAppUtilization[$IamHere].value
    $MyVolumes+=$myNewObject
}
$MyVolumes = $MyVolumes | Where-Object -FilterScript {$_.name -notlike '*snapshot*' -and $_.name -notlike '*root*' -and $_.utilization -ge 98}
