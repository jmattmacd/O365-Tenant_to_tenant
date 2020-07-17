# connect-exchangeonline
$mbxs = get-mailbox -ResultSize unlimited | where {$_.ForwardingSMTPAddress -ne $null}
ForEach ($mbx in $mbxs) {
    Set-Mailbox -Identity $mbx.Alias -ForwardingSmtpAddress $null -DeliverToMailboxAndForward $True
}
