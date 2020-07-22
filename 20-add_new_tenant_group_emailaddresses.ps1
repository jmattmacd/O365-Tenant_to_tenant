# connect-exchangeonline

$GroupMembers = import-csv ".\03-output-groups_and_members.csv"

$groups = $GroupMembers | select GroupObjectID,GroupName,EmailAddresses -Unique

$i=0
ForEach ($Group in $Groups) {
    $group.GroupName
    $group.EmailAddresses

    $i++
    Write-Host "Rebuilding User " $i "of" $users.count $user.UserPrincipalName
    $ProxyAddresses = $group.EmailAddresses.Split(";")
    ForEach($Address in $ProxyAddresses){
        If ($Address -clike "smtp*"){ 
            Write-Host "Recreating Proxy Addresses" $Address -ForegroundColor Yellow
            $arr_addresses = (Get-UnifiedGroup -Identity $Group.GroupObjectID).EmailAddresses
            If ($Address -notin $arr_addresses) {
                $arr_addresses += $Address
                write-host $arr_addresses
             #   Set-UnifiedGroup -Identity $Group.GroupObjectID -EmailAddresses $arr_addresses
            }       
        }
        If ($Address -clike "SMTP*"){ 
            Write-Host "Recreating Proxy Addresses" $Address.Replace("SMTP","smtp") -ForegroundColor Yellow
            $arr_addresses = (Get-UnifiedGroup -Identity $Group.GroupObjectID).EmailAddresses
            If ($Address -notin $arr_addresses) {
                $arr_addresses = $arr_addresses.Replace("SMTP","smtp")
                $arr_addresses += $Address
                write-host $arr_addresses
                Set-UnifiedGroup -Identity $Group.GroupObjectID -EmailAddresses $arr_addresses
            }
        } 
    }
}