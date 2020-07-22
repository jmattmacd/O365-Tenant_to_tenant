$GroupMembers = Import-CSv ".\06-output-distribution_group_members.CSV"

ForEach ($groupmember in $GroupMembers) {
    Write-Host "Adding" $groupmember.Member "to" $groupmember.DistroGroupName
    Add-DistributionGroupMember -Identity $groupmember.DistroGroupName -Member $groupmember.Member
}