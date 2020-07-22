# connect-exchangeonline

$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"

$OutfileMembers = ".\06-output-distribution_group_members.CSV"
$OutfileGroups = ".\06-output-distribution_groups.CSV"

if (Test-Path $OutfileMembers) 
{
  Remove-Item $OutfileMembers
}
$content = "DistroGroupName,Member"
Add-Content -Path $OutfileMembers $content

if (Test-Path $OutfileGroups) 
{
  Remove-Item $OutfileGroups
}
$content = "DistroGroupName,AcceptMessagesOnlyFrom,AcceptMessagesOnlyFromDLMembers,AcceptMessagesOnlyFromSendersOrMembers,AddressListMembership,Alias,BypassModerationFromSendersOrMembers,Description,EmailAddresses,EmailAddressPolicyEnabled,GrantSendOnBehalfTo,GroupType,HiddenFromAddressListsEnabled,Identity,IsDirSynced,ManagedBy,MemberJoinRestriction,ModeratedBy,ModerationEnabled,Name,PrimarySmtpAddress"
Add-Content -Path $OutfileGroups $content



$distrogroups=Get-DistributionGroup -ResultSize unlimited
$i=0
ForEach ($distrogroup in $distrogroups){
    $i = $i+1
    Write-Host "Processing Group" $i "of" $distrogroups.Count $distrogroup.displayname -ForegroundColor Yellow
    $DistroMembers = Get-DistributionGroupMember -Identity $distrogroup.PrimarySmtpAddress -ResultSize unlimited
    ForEach ($member in $DistroMembers) {
        If ($member.PrimarySMTPAddress -like $DomainName1 -or $member.PrimarySMTPAddress -like $DomainName2) {
            If ($MatchedGroup -ne $distrogroup) {
                Write-Host "New group" -foregroundcolor Red
                $managedby = ""
                ForEach ($person in $distrogroup.ManagedBy) {
                    $managedby = $managedby+";"+$person
                }
                $moderationbypass = ""
                ForEach ($person in $distrogroup.BypassModerationFromSendersOrMembers) {
                    $person
                    $moderationbypass = $moderationbypass+";"+$person
                }
                $moderatedby = ""
                ForEach ($person in $distrogroup.ModeratedBy) {
                    $person
                    $moderatedby = $moderatedby+";"+$person
                }
                $acceptmessagesfrom = ""
                ForEach ($person in $distrogroup.AcceptMessagesOnlyFrom) {
                    $person
                    $acceptmessagesfrom = $acceptmessagesfrom+";"+$person
                }
                $AcceptMessagesOnlyFromSendersOrMembers = ""
                ForEach ($person in $distrogroup.AcceptMessagesOnlyFromSendersOrMembers) {
                    $person
                    $AcceptMessagesOnlyFromSendersOrMembers = $AcceptMessagesOnlyFromSendersOrMembers+";"+$person
                }
                $content = $distrogroup.DisplayName+","+$acceptmessagesfrom.TrimStart(";")+","+$distrogroup.AcceptMessagesOnlyFromDLMembers+","+$AcceptMessagesOnlyFromSendersOrMembers.TrimStart(";")+","+$distrogroup.AddressListMembership+","`
                    +$distrogroup.Alias+","+$moderationbypass.TrimStart(";")+","+$distrogroup.Description+","+$distrogroup.EmailAddresses+","+$distrogroup.EmailAddressPolicyEnabled+","+$distrogroup.GrantSendOnBehalfTo+","`
                    +$distrogroup.GroupType.Replace(","," ")+","+$distrogroup.HiddenFromAddressListsEnabled+","+$distrogroup.Identity+","+$distrogroup.IsDirSynced+","+$managedby.TrimStart(";")+","+$distrogroup.MemberJoinRestriction+","+$moderatedby.TrimStart(";")+","`
                    +$distrogroup.ModerationEnabled+","+$distrogroup.Name+","+$distrogroup.PrimarySmtpAddress
                Add-Content -Path $OutFileGroups $content
            }          
            $MatchedGroup = $distrogroup
            write-host $member.PrimarySMTPAddress
            $content = $distrogroup.displayname+","+$member.PrimarySmtpAddress
            Add-Content -Path $OutFileMembers $content
        }
    }
} 


