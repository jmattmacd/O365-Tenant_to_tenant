# Connect-MSOLService
$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"

$NewOnMicrosoftDomainName = "newdomain.onmicrosoft.com"

$users = Import-csv ".\01-output-inscope_users.csv"
$i=0
ForEach ($user in $users) {
    $i++
    Write-Host "Rebuilding User " $i "of" $users.count $user.UserPrincipalName
    $OnMSUPN = ($user.UserPrincipalName.Replace($DomainName1.Replace("*@",""),$NewOnMicrosoftDOmainName)).Replace($DomainName2.Replace("*@",""),$NewOnMicrosoftDOmainName)
    Write-Host "Existing UPN" $OnMSUPN "reverting to original" -ForegroundColor yellow
    Set-MsolUserPrincipalName -UserPrincipalName $OnMSUPN -NewUserPrincipalName $user.UserPrincipalName
}