@description('The name of the Key Vault')
param name string

@description('The location for the Key Vault')
param location string

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault')
param enableVaultForDeployment bool = true

@description('Role assignments to be applied to the Key Vault')
param roleAssignments array

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enabledForDeployment: enableVaultForDeployment
    accessPolicies: []
  }
}
output resourceId string = keyVault.id
// Rename the resource declaration to avoid the naming conflict
resource keyVaultRoleAssignments 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for roleAssignment in roleAssignments: {
  name: guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    principalType: roleAssignment.principalType
  }
}]
