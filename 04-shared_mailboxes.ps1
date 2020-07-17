# connect-exchangeonline

$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"
$Outfile = ".\04-output-shared_mailboxes.csv"
if (Test-Path $Outfile) 
{
  Remove-Item $Outfile
}
$content = "SharedMailboxName,SharedMailboxAddress,User"
Add-Content -Path $OutFile $content


$AllSMBs = get-mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

$i=0
ForEach ($SMB in $AllSMBs){
    $i = $i+1
    Write-Host "Processing SMB" $i "of" $AllSMBs.Count -ForegroundColor Yellow
    Write-Host $SMB.Name -ForegroundColor Yellow
    $SMBMembers = Get-MailboxPermission -Identity $SMB.Alias
    $SMBStats = Get-MailboxStatistics -Identity $SMB.UserPrincipalName
    ForEach ($SMBMember in $SMBMembers) {
        If ($SMBMember.User -like $DomainName1 -or $SMBMember.User -like $DomainName2) {
        $SMB.Name 
        $SMBMember.User
        $content = $SMB.Name+","+$SMB.PrimarySmtpAddress+","+$SMBMember.User+","+$SMBStats.ItemCount+","+$SMBStats.TotalItemSize
        Add-Content -Path $OutFile $content
        }
    }
    
}