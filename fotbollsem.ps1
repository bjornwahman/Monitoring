# Get matchdata from European championship 2021, display it in Home Assistant
while ($true) {
    $em = New-Object System.Xml.XmlDocument
    $em.Load("https://crssnt.com/preview?id=1Bn6_2XtMY0eLKqPdKXgaTESZ_oic24FeifBrErwPaf4&mode=title")
    $null | Out-File /mnt/temp/match.txt
    $latestmatches = $em.rss.channel.item.title
    foreach ($match in $latestmatches) {
        $output = $match | select -ExpandProperty "#cdata-section"
        $dagensmatcher = $output.trim("  -")
        $dagensmatcher | Out-File -append /mnt/temp/match.txt
    }
    Start-Sleep -s 3600
}
