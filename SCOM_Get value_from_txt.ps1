### Define Operations Manager objects ###
$momScriptAPI = new-object -comObject 'MOM.ScriptAPI'
$bag = $momScriptAPI.CreatePropertyBag();
	
$ScriptName = "CheckLogFileCount.ps1"
$version = "0.8"
$scriptOutput = ""

#Insert Variables


function Write-Event($EventID, $Severity, $Message)
{
    $momScriptAPI.LogScriptEvent($scriptName, $EventID, $Severity, "Version: $version`n$Message")
}
function Write-InfoEvent($EventID, $Message)
{
    Write-Event -EventID $EventID -Severity 0 -Message $Message
}
function Write-WarningEvent($EventID, $Message)
{
    Write-Event -EventID $EventID -Severity 2 -Message $Message
}
function Write-ErrorEvent($EventID, $Message)
{
	Write-Event -EventID $EventID -Severity 1 -Message $Message
}
function Exit-Script()
{
	#EventID should be changed
    Write-InfoEvent -EventID 4480 -Message $scriptOutput
	exit
}

#EventID should be changed
Write-InfoEvent -EventID 4450 -Message "Running script."


$ErrorActionPreference = "Stop"
$scriptOutput += "Script started.`n"

$file = "C:\Tivoli\Passwordsynch\log\PwdSync.log"
$textstring = "Starting new thread.  Thread count:"
[int]$threshold = "45"

    try 
    {
        $threadcount = Get-Content "$file" -ErrorAction $ErrorActionPreference
    }
    catch 
    {
        Write-WarningEvent -EventID 4460 -Message "File not found`n$_"
        
    }



$threadcount = $threadcount -match "$textstring" | select-object -Last 1
# Below, Added a check to see if we have data in threadcount and if not exit script
if ($threadcount.count -eq 0)
    {
    Write-WarningEvent -EventID 4465 -Message "No thread data was found, maybe the log rotated"
    exit   
    }
    else
    {
    Write-InfoEvent -EventID 4466 -Message "We have data in threadcount, lets continue"
    }
# Above, Added a check to see if we have data in threadcount and if not exit script

$scriptOutput += "`tFound Thread Perfdata $threadcount`n"
$data = $threadcount -replace ".*count:"
$match = $data -match "\d*$"
$scriptOutput += "`tdata after regexp $match`n"
[int]$threadperfdata = $Matches[0]
$scriptOutput += "`tFound Thread Perfdata $threadperfdata`n"
$scriptOutput += "`tFound Thread Type $threadperfdata.GetType().Name`n"

    if ($threadperfdata -gt $threshold)
    {

        $scriptOutput += "`tThreadCount is greater then threshold: $threshold`n"
        $scriptOutput += "`tSetting Result to 'BAD'.`n"
        $bag.AddValue('Result','BadCondition')
    }

    else 

    {
        $scriptOutput += "`tThreadCount is below threshold: $threshold`n"
        $scriptOutput += "`tSetting Result to 'GOOD'.`n"
		$bag.AddValue('Result','GoodCondition')
    }


### Add property bag values ###
$bag.AddValue('threshold',"$threshold")
$bag.AddValue('threadperfdata',"$threadperfdata")


### Return property bag
$bag

#EventID should be changed     
Write-InfoEvent -EventID 4470 -Message $scriptOutput
