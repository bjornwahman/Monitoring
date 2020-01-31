$rows = Get-Content hosts.txt

$sucess = foreach ($row in $rows) {

    if ($dns = Resolve-DnsName -Name $row -ErrorAction ignore){
        write-host $dns.NameHost
    }
}