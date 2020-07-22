# Connect-MSOLService
$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$Outfile = ".\01-output-inscope_users.csv"

$content = "userprincipalname, GivenName, Surname, DisplayName, mailNickName, proxyaddresses"
Add-Content -path $outfile $content

$Scopedusers = Get-MSOLUser -DomainName $DomainName1.Replace("*@","") 
$Scopedusers += Get-MSOLUser -DomainName $DomainName2.Replace("*@","") 

ForEach ($User in $ScopedUsers) {
    $ProxyString = ""
    ForEach ($address in $User.ProxyAddresses) {
        If ($address -like $DomainName1 -or $address -like $DomainName2) {
            $ProxyString = $ProxyString+";"+$address
            
        }
    }
    Write-Host $user.UserPrincipalName -foregroundcolor Red
    Write-Host $ProxyString.TrimStart(";")
    $content = $user.UserPrincipalName+","+$user.FirstName+","+$user.LastName+","+$user.DisplayName+","+($user.UserPrincipalName.Replace($DomainName1.Replace("*",""), "")).Replace($DomainName2.Replace("*",""), "")+","+$ProxyString.TrimStart(";")
    Add-Content -path $Outfile $content
}


Write-Host "Found" $Scopedusers.Count "users"

