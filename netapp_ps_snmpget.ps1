#Install-Module -Name Proxx.SNMP 
$NetappVolumes = Invoke-SnmpWalk -IpAddress 10.66.32.114 -Community "fR0yd1s" -Version Ver2 -Oid ".1.3.6.1.4.1.789.1.5.4.1.2"
$NetappUtilization = Invoke-SnmpWalk -IpAddress 10.66.32.114 -Community "fR0yd1s" -Version Ver2 -Oid ".1.3.6.1.4.1.789.1.5.4.1.6"
#Smash together Volume and Utilization data
$MyVolumes=@()
$IamHere=-1
foreach ($volume in $NetappVolumes){
    $IamHere++
    $myNewObject = New-Object System.Object
    $myNewObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $volume.value
    $myNewObject | Add-Member -MemberType NoteProperty -Name "Utilization" -Value $NetappUtilization[$IamHere].value
    $MyVolumes+=$myNewObject
}
$MyVolumes | Where-Object -FilterScript {$_.name -notlike '*snapshot*' -and $_.utilization -ge 90}