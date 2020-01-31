###################
##Björn Wahman 2019-11-12
##
##Checks for something called a "SendPorts" in an application named "Biztalk"... :)
###################
$Biztalk_server = "SQL SERVER"

[void] [System.Reflection.Assembly]::loadwithPartialName("Microsoft.BizTalk.ExplorerOM");

$BTSexp = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer;

$BTSexp.ConnectionString = `
"Server=$Biztalk_server;Initial Catalog=BizTalkMgmtDb;Integrated Security=SSPI;";
$y = 0; [Array] $MyNewObject = $null;
$y = 0; [Array] $MyNewObject = $null;
$myObjects=@()
$MyNewObject = foreach($item in ($BTSexp.SendPorts))
{
$newPSitem = New-Object PSObject -Property @{
seq = $y.ToString("000");
Application = $item.Application.name;
Status = $item.Status;
Port = $item.Name;
}
$myObjects+=$newPSitem
}
$statuscode = 0
$statusOutput = "OK: SendPort $($item.name) is started"

$myErrorObjects=@()
foreach ($object in $myObjects){
    if ($object.status -ne "started"){
        $myErrorObjects+=$object
    }
}

if ($myErrorObjects.count -gt 0){
    $statuscode=2
    $statusOutput = "CRITICAL Check these SendPort: "
    $myErrorObjects | ForEach-Object {
        $statusOutput = $statusOutput + $_.port + ", "
    }
    $statusOutput = $statusOutput.TrimEnd(", ")
}

Write-Host $statusOutput

exit $statuscode