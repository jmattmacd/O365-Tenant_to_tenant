# connect-exchangeonline
$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$TempDomainName = "tempdomain.com"

#$sharedmbxs = get-mailbox -RecipientTypeDetails shared -ResultSize unlimited
$sharedmbxs = get-mailbox "testfr-shared"

$i=0
ForEach($mbx in $sharedmbxs) {
    $i++
    Write-Host "Checking Mailbox" $i "of" $sharedmbxs.Count "-" $mbx.DisplayName
    $mbx.emailaddresses
    :exitloop ForEach($EmailAddress in $mbx.EmailAddresses) {
        If ($EmailAddress -like $DomainName1 -or $EmailAddress -like $DomainName2) {
            $emailaddresstring = ($mbx.EmailAddresses.Replace($domainname1.Replace("*@",""),$TempDomainName)).Replace($DomainName1.Replace("*@",""),$TempDomainName)
            $emailaddresstring
            Set-Mailbox -Identity $mbx.DisplayName -EmailAddresses $emailaddresstring
            break exitloop
        }
    }

}