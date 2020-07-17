# Connect-AzureAD
$DomainName1 = "arriva.com.hr"
$DomainName2 = "arriva.fr"
$TargetDomainName = "northernrailmigration.co.uk"
$Users = Import-Csv -Path .\01-output-inscope_users.csv
$i=0
ForEach ($User in $Users) {
    $i++
    Write-Host $i "of" $users.COunt "-" $User.UserPrincipalName
    $newupn =  $user.UserPrincipalName.Replace($DomainName1,$TargetDomainName).Replace($DomainName2,$TargetDomainName)
    $PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $random = Get-random -Maximum 99999
    $PasswordProfile.Password="Passwords!"+$random
    New-AzureADUser -UserPrincipalName $user.UserPrincipalName.Replace($DomainName1,$TargetDomainName).Replace($DomainName2,$TargetDomainName) -DisplayName $User.DisplayName -GivenName $User.GivenName -Surname $user.Surname -AccountEnabled $true -PasswordProfile $PasswordProfile -MailNickName $user.mailNickName
}