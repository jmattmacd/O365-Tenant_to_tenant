# Connect-MSOLService
$ADFSServerFQDN = "ADFS01.thisdomain.com"
$DomainName1 = "thisdomain.com"

Set-MSOLADFSContext -Computer $ADFSServerFQDN
Convert-MsolDomainToStandard -DomainName $DomainName1 -SkipUserConversion:$true -PasswordFile .\userpasswords.txt 