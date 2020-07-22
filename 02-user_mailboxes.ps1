#  connect-exchangeonline

$Outfile = ".\02-output-user_mailboxes.csv"
if (Test-Path $Outfile) 
{
  Remove-Item $Outfile
}
$content = "UserPrincipalName,Archive,ItemCount,TotalItemSize"
Add-Content -Path $OutFile $content

$scopedusers = import-csv -Path .\01-output-inscope_users.csv

$i = 0
ForEach ($user in $scopedusers){
    $i = $i+1
    Write-Host "Procesing User" $i "of" $scopedusers.Count -ForegroundColor Yellow
    Write-Host $user.UserPrincipalName -ForegroundColor Yellow
    $ThisMBX = Get-Mailbox $user.UserPrincipalName
    $ThisMBXStats = Get-MailboxStatistics $user.UserPrincipalName
    If ($ThisMBX) {
        $content = $ThisMBX.UserPrincipalName+","+$ThisMBX.ArchiveStatus+","+$ThisMBXStats.ItemCOunt+","+$ThisMBXStats.TotalItemSize
        $content
        Add-Content -Path $OutFile $content
    }
}
