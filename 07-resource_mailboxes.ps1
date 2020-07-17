# connect-exchangeonline

$DomainName1 = "*@thisdomain.com"
$DomainName2 = "*@thatdomain.com"

Get-Mailbox -ResultSize unlimited -Filter {(RecipientTypeDetails -eq 'RoomMailbox')} | where {$_.PrimarySMTPAddress -like $DomainName1 -or $_.PrimarySMTPAddress -like $DomainName2} | select PrimarySMTPAddress | Export-Csv -Path ".\07-output-resource_mailboxes.CSV"