# =========================================================== power shell script for resetting permission ========================


param(
    [string]$UserprincipalName
    [string]$NewRole = "Reader",
    [string]$scopeType = "ResourceGroup",
    [string]$ScopeName

)


# connect via managed Identity or sp

connect-Azaccount -Identity



# Get user ID
$user = Get-AzADuser -UserprincipalName $userprincipalName
if (-not $user) {
    write-Error "User not found: $UserprincipalName"
    exit 1

}

# Define Scope
$subId = (Get-AzContext).subscription.Id
$scope = if ($scopeType -eq "ResourceGroup") {
    "/subscriptions/$subId/resourceGroups/$ScopeName"
} else {
    "/subscriptions/$subId"

}


# Remove all existing role assignments for the user
$assignments = Get-AzRoleAssignment -objectId $user.Id -scope $scope
foreach ($assignment in $assignments) {
    Remove-AzRoleAssignment -ObjectId $user.Id -RoledefinitionName $assignment.RoleDefination $scope $scope -ErrorAction silentlycontinue 
    write-output "Removed role: $(assignment.RoleDefinitionName)"

}

#Assign new role (e.g., Reader)
New-AzRoleAssignment -objectId $user.Id -RoleDefinitionName $NewRole -scope $scope 
write-output "Assignment new role '$userprincipalname at $scope"