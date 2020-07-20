# Connect-MSOLService
# Connect-ExchangeOnline
$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$TempDomainName = "tempdomain.com"


$users = get-msoluser -All -DomainName $TempDomainName
$i=0
ForEach ($user in $users) {
    $i++
    Write-Host $i "of" $users.count "-" $user.UserPrincipalName
    ForEach ($proxyaddress in $user.ProxyAddresses) {
        If ($proxyaddress -clike "smtp*" -and ($proxyaddress -like $DomainName1 -or $proxyaddress -like $DomainName2)) {
            $proxyaddress
            Set-Mailbox -Identity $User.UserPrincipalName -EmailAddresses @{Remove=$proxyaddress}      
        }
    }
}