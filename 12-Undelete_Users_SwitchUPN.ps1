# Connect-MSOLService
$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$TempDomainName = "tempdomain.com"


$deletedusers = Get-MsolUser -All |where-object {$_.UserPrincipalName -like $DomainName1 -or $_.UserPrincipalName -like $DomainName2}
$outfile = ".\12-output-ChangedUPNs.csv"
$content = "OldUPN,NewUPN"
Add-COntent -Path $outfile $content


$i=0
ForEach ($user in $deletedusers) {
    $i++
    Write-Host "Recovering User" $i "of" $deletedusers.count "-" $user.UserPrincipalName
    $newUPN = ($user.UserPrincipalName.Replace($DomainName1.Replace("*@",""),$TempDomainName)).Replace($DomainName2.Replace("*@",""),$TempDomainName)
    Restore-MSOLUser -UserPrincipalName $user.UserPrincipalName -NewUserPrincipalName $newUPN
    Set-msoluser -UserPrincipalName $newUPN -ImmutableId "$null"
    Write-Host "Recovering User" $i "of" $deletedusers.count "-" $user.UserPrincipalName
    Write-Host "Recovered as" $newUPN
    $content = $user.UserPrincipalName+","+$newUPN
    Add-Content -Path $outfile $content
}

$recoveredusers = get-msoluser -DomainName $TempDomainName

$j=0
ForEach ($recovereduser in $recoveredusers) {
$j++
    Write-Host $j.ToString() $recovereduser.UserPrincipalName
    $password = Set-MsolUserPassword -UserPrincipalName $recovereduser.UserPrincipalName -NewPassword "P#ZweVn^TX6Dg4kr"
    Set-MsolUser  -UserPrincipalName $recovereduser.UserPrincipalName -BlockCredential $true
}