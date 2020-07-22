$TempDomainName = "tempdomain.com"

$Tempusers = get-msoluser -DomainName $TempDomainName -All

$i=0
ForEach ($Tempuser in $Tempusers) {
$i++
    Write-Host $i.ToString() $Tempuser.UserPrincipalName
    Remove-MsolUser -UserPrincipalName $Tempuser.UserPrincipalName -Force
}