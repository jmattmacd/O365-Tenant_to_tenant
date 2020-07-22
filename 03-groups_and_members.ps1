# Connect-ExchangeOnline
# Connect-AzureAD

$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"

$Outfile = ".\03-output-groups_and_members.csv"
if (Test-Path $Outfile) 
{
  Remove-Item $Outfile
}
$content = "GroupObjectID,GroupName,GroupType,DirSync,EmailAddresses,Member"
Add-Content -Path $OutFile $content

$allgroups = Get-UnifiedGroup -ResultSize  unlimited
$i = 0

ForEach ($ThisGroup in $allgroups){
    $i = $i+1
    Write-Host "Processing Group" $i "of" $allgroups.Count -ForegroundColor Yellow
    Write-Host $ThisGroup.DisplayName -ForegroundColor Yellow 
    $ThisGroup.EmailAddresses
    $ProxyString = ""
    ForEach ($address in $ThisGroup.EmailAddresses) {
        If ($address -like $DomainName1 -or $address -like $DomainName2 -and $address -like "smtp*") {
            $ProxyString = ($ProxyString+";"+$address).TrimStart(";")
        }
    }
    $ThisGroupMembers = Get-AzureADGroupMember -ObjectId $ThisGroup.ExternalDirectoryObjectID
    ForEach ($ThisMember in $ThisGroupMembers) {
        If ($ThisMember.UserPrincipalName -like $DomainName1 -or $ThisMember.UserPrincipalName -like $DomainName2) {
            $content=$ThisGroup.ExternalDirectoryObjectID+","+$Thisgroup.DisplayName.Replace(",","")+","+$ThisGroup.GroupType+","+$Thisgroup.IsDirSynced+","+$proxystring+","+$ThisMember.UserPrincipalName
            Add-Content -Path $OutFile $content
        }
    }
}