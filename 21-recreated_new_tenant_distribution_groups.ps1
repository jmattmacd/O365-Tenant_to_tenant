# connect-ExchangeOnline

$Groups = Import-Csv ".\06-output-distribution_groups_test.CSV"

$i=0
ForEach ($Group in $Groups) {
    $i++
    Write-Host "Rebuilding group" $i "of" $Groups.Count "-" $Group.DistroGroupName
    If ($group.moderationenabled -eq "TRUE") {
        $moderationenabled = 1
    }
    Else {
        $moderationenabled = 0
    }
    $AcceptMessagesOnlyFrom = $Group.AcceptMessagesOnlyFrom.Split(";")
    $ModeratedBy = $Group.ModeratedBy.Split(";")
    $ManagedBY = $group.ManagedBy.Split(";")
    $BypassModerationFromSendersOrMembers = $group.BypassModerationFromSendersOrMembers.Split(";")
    If ($group.HiddenFromAddressListsEnabled -eq "TRUE") {
        $HiddenFromAddressListsEnabled = 1
    }
    Else {
        $HiddenFromAddressListsEnabled = 0
    }
    $AcceptMessagesOnlyFromSendersOrMembers = $Group.AcceptMessagesOnlyFromSendersOrMembers.Split(";")
    New-DistributionGroup -Name $Group.Name -ModerationEnabled $moderationenabled -ModeratedBy $ModeratedBy -MemberJoinRestriction $group.MemberJoinRestriction -ManagedBy $managedby -Alias $group.Alias
    Set-DistributionGroup -Identity $Group.Name -BypassModerationFromSendersOrMembers $BypassModerationFromSendersOrMembers -HiddenFromAddressListsEnabled $HiddenFromAddressListsEnabled -AcceptMessagesOnlyFromSendersOrMembers $AcceptMessagesOnlyFromSendersOrMembers
    $ProxyAddresses = $group.EmailAddresses.Split(" ")
    $arr_addresses =@()
    ForEach($Address in $ProxyAddresses){
        If ($Address -clike "smtp*"){ 
            Write-Host "Recreating Proxy Addresses" $Address -ForegroundColor Yellow
            $arr_addresses = (Get-DistributionGroup -Identity $Group.Name).EmailAddresses
            If ($Address -notin $arr_addresses) {
                $arr_addresses += $Address
                write-host $arr_addresses
                Set-DistributionGroup -Identity $Group.Name -EmailAddresses $arr_addresses
            }       
        }
        If ($Address -clike "SMTP*"){ 
            Write-Host "Recreating Proxy Addresses" $Address.Replace("SMTP","smtp") -ForegroundColor Yellow
            $arr_addresses = (Get-DistributionGroup -Identity $Group.Name).EmailAddresses
            If ($Address -notin $arr_addresses) {
                $arr_addresses += $Address
                write-host $arr_addresses
                Set-DistributionGroup -Identity $Group.Name -EmailAddresses $arr_addresses
            }
        } 
    }
}