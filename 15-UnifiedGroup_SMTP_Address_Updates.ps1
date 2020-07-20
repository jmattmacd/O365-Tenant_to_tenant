# Connect-exchangeonline
$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$TempDomainName = "tempdomain.com"
$groups =  Get-UnifiedGroup -ResultSize Unlimited 


ForEach($group in $groups) {
    If($group.PrimarySmtpAddress -like $DomainName1 -or $group.PrimarySMTPAddress -like $DomainName2) {
        $newprimary = ($group.PrimarySmtpAddress.Replace($DomainName2.Replace("*@",""),$TempDomainName)).Replace($DomainName1.Replace("*@",""),$TempDomainName)
        Write-Host "Re-writing Primary Address " $Group.DisplayName "-" $group.PrimarySmtpAddress "-" $newprimary
        get-unifiedgroup $group.DisplayName | Set-UnifiedGroup -PrimarySmtpAddress $newprimary    
    }
}

$groups =  Get-UnifiedGroup -ResultSize Unlimited 


ForEach($group in $groups) {
    ForEach ($emailaddress in $group.EmailAddresses) {
        If($emailaddress -like $DomainName1 -or $group.PrimarySMTPAddress -like $DomainName2) {
            $newaddress = ($emailaddress.Replace($DomainName2.Replace("*@",""),$TempDomainName)).Replace($DomainName1.Replace("*@",""),$TempDomainName)
            write-host "-Re-writing Secondary Address "$emailaddress "-" $newaddress
            get-unifiedgroup $group.DisplayName | Set-UnifiedGroup -EmailAddresses @{Add=$newaddress}
            get-unifiedgroup $group.DisplayName | Set-UnifiedGroup -EmailAddresses @{Remove=$emailaddress}
        }
    }
}
