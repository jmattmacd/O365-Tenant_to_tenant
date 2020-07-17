# Connect-AzureAD
$DomainName1 = "*@arriva.com.hr"
$DomainName2 = "*@arriva.fr"
$Scopedusers = Get-AzureADUser -all $true | where {$_.userprincipalname -like $DomainName1} | select userprincipalname, GivenName, Surname, DisplayName, mailNickName
$Scopedusers+= Get-AzureADUser -all $true | where {$_.userprincipalname -like $DomainName2} | select userprincipalname, GivenName, Surname, DisplayName, mailNickName
$Scopedusers | export-csv -Path ".\01-output-inscope_users.csv"
Write-Host "Found" $Scopedusers.Count "users"