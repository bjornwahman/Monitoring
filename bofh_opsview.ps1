$url = "http://jefflane.org/bofh/bofh.pl"
$response = Invoke-WebRequest -Uri $url
$texttomanipulate = $response.ParsedHtml.body.outerText
$texttomanipulate = $texttomanipulate.TrimEnd("The BOFH-style excuse generator brought to you by Jeff Ballard. The cause of the problem is:")
$texttomanipulate = $texttomanipulate.TrimStart('"The Bastard Operator From Hell"-style excuse server.')
$texttomanipulate = $texttomanipulate -replace ".*:"
$texttomanipulate = $texttomanipulate.Trim()
$statuscode = 0
Write-Host $texttomanipulate
exit $statuscode