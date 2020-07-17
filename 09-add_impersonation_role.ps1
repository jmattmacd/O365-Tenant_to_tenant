# connect-exchangeonline
$username = "GlobalAdminUser@domain.com"

New-RoleGroup -Name "OnDemandMigration" -Description "Temprorary Role Group For Migration" -Roles "ApplicationImpersonation" -Members $username