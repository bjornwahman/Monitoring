$cert = (Get-ChildItem -Path \\share$\user\*.cer)

foreach ($c in $cert){
$cer = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cer.Import("$c")


$certexpire = $cer.NotAfter.AddDays(-30)
$date = Get-Date 
# Test datum string
# $date = [DateTime]"01/12/2022 15:02:26"
     $compare = ($certexpire) -lt ($date)

        if ($compare -eq $false) {
        $Output = "OK: Certificate is valid, Certificate expire date is $certexpire"
        Write-Output $Output
        }
        if ($compare -eq $true) {
        $Output = "Critical: Certificate will soon expire or has already expired, Certificate expire date is $certexpire"
        Write-Output $Output
        }
}
