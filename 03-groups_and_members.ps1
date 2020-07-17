# Connect-AzureAD

$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$Outfile = ".\03-output-groups_and_members.csv"
if (Test-Path $Outfile) 
{
  Remove-Item $Outfile
}
$content = "GroupObjectID,GroupName,Security,DirSync,Member"
Add-Content -Path $OutFile $content

$allgroups = Get-AzureADGroup -All $true

$i = 0

ForEach ($ThisGroup in $allgroups){
    $i = $i+1
    Write-Host "Processing Group" $i "of" $allgroups.Count -ForegroundColor Yellow
    Write-Host $ThisGroup.DisplayName -ForegroundColor Yellow
    $ThisGroupMembers = Get-AzureADGroupMember -ObjectId $ThisGroup.ObjectID
    ForEach ($ThisMember in $ThisGroupMembers) {
        If ($ThisMember.UserPrincipalName -like $DomainName1 -or $ThisMember.UserPrincipalName -like $DomainName2) {
            $content=$ThisGroup.ObjectID+","+$Thisgroup.DisplayName+","+$Thisgroup.SecurityEnabled+","+$Thisgroup.DirSyncEnabled+","+$ThisMember.UserPrincipalName
            Add-Content -Path $OutFile $content
        }
    }
}