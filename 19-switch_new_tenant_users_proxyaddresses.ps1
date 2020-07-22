# connect-exchangeonline

$users = Import-csv ".\01-output-inscope_users.csv"
$i=0
ForEach ($user in $users) {
    $i++
    Write-Host "Rebuilding User " $i "of" $users.count $user.UserPrincipalName
    $ProxyAddresses = $user.proxyaddresses.Split(";")
    ForEach($Address in $ProxyAddresses){
        If ($Address -clike "smtp*"){ 
            Write-Host "Recreating Proxy Addresses" $Address -ForegroundColor Yellow
            $arr_addresses = (Get-Mailbox -Identity $user.userprincipalname).EmailAddresses
            If ($Address -notin $arr_addresses) {
                $arr_addresses += $Address
                write-host $arr_addresses
                Set-Mailbox -Identity $user.userprincipalname -EmailAddresses $arr_addresses
            }       
        }
        If ($Address -clike "SMTP*"){ 
            Write-Host "Recreating Proxy Addresses" $Address.Replace("SMTP","smtp") -ForegroundColor Yellow
            $arr_addresses = (Get-Mailbox -Identity $user.userprincipalname).EmailAddresses
            If ($Address -notin $arr_addresses) {
                $arr_addresses += $Address.Replace("SMTP","smtp")
                write-host $arr_addresses
                Set-Mailbox -Identity $user.userprincipalname -EmailAddresses $arr_addresses
            }
        }
    }
}