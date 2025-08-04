# ===================Powershell script for Role Assignment ==================

param( 
    [string]$userprincipalName,
    [string]$Role,
    [string]$Stage,
    [string]$scopeType = "resourceGroup"
    [string]$ScopeName



)

# Authenticate

Connect-AzAccount -Identity



# Get user ID
$User = Get-AzADuser -UserPrincipaloName $userprincipalName
if (!$user) {
    write-error "User not found: $UserPrincipalName"
    exit 1
}


# Define Scope 

$subId = (Get-AzContext).Subscription.ID
$Scope = if ($Scopetype -eq "ResourceGroup") {
    "/subscription/$subId/resourceGroup/$ScopeName"
} else {
    "/subscriptions/$subId"

}
 

# Assign role

mew-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName $Role -Scope $scope 
write-Output "[$stage] Role '$Role' assigned to '$userprincipalName' at 'scope'"





