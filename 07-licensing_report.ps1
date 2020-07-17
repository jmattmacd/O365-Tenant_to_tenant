# connect-azuread

$Outfile = ".\07-output-licensing_report.CSV"
if (Test-Path $Outfile) 
{
  Remove-Item $Outfile
}
$content = "UserPrincipalName,License"
Add-Content -Path $OutFile $content


$scopedusers = import-csv -Path .\01-output-inscope_users.csv
$OurSkus = Get-AzureADSubscribedSku
$i = 0

ForEach ($scopeduser in $scopedusers){
    $i = $i+1
    Write-Host "Processing User" $i "of" $scopedusers.Count -ForegroundColor Yellow
    $ThisUser = Get-AzureADUser -ObjectId $scopeduser.UserPrincipalName
    Write-Host $scopeduser.UserPrincipalName -ForegroundColor Yellow
    $userskus = $ThisUser | select UserPrincipalName -ExpandProperty AssignedLicenses
        ForEach ($usersku in $userskus) {
        write-host $usersku.UserPrincipalName $usersku.SkuID
        $ThisSku = $OurSkus | where {$_.SkuId -eq $usersku.SkuId} |select SkuPartNumber
        $content = $ThisUser.UserPrincipalName+","+$ThisSku
        Add-Content -Path $OutFile $content
    }
}
