#Connect-MicrosoftTeams

$Outfile = ".\04-output-teams.csv"
if (Test-Path $Outfile) 
{
  Remove-Item $Outfile
}

$groupmembers = import-csv .\03-output-groups_and_members.csv

$groups = $groupmembers.GroupName | get-unique | Sort-Object

$i = 0
ForEach ($group in $groups) {
$i = $i+1
    Write-host $i "of" $groups.Count $group
    $team = Get-Team -DisplayName $group
    If ($team) {
        write-host "Found One!" $team.DisplayName -ForegroundColor Red
        $team | Export-Csv -Path $Outfile -Append

    }
}