@description('The name of the Azure Container Registry')
param name string

@description('The location for the Azure Container Registry')
param location string

@description('Enable admin user for the Azure Container Registry')
param acrAdminUserEnabled bool = true

@description('The resource ID of the Key Vault where ACR credentials will be stored')
param adminCredentialsKeyVaultResourceId string

@description('The name of the Key Vault secret for the admin username')
@secure()
param adminCredentialsKeyVaultSecretUserName string

@description('The name of the Key Vault secret for the first admin password')
@secure()
param adminCredentialsKeyVaultSecretUserPassword1 string

@description('The name of the Key Vault secret for the second admin password')
@secure()
param adminCredentialsKeyVaultSecretUserPassword2 string

// Create the Azure Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

// Get a reference to the existing Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  scope: resourceGroup()
  name: last(split(adminCredentialsKeyVaultResourceId, '/')) // Extract name from the Resource ID
}

// Store the admin username as a Key Vault secret
resource secretAdminUsername 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: keyVault
  name: adminCredentialsKeyVaultSecretUserName
  properties: {
    value: containerRegistry.properties.adminUserEnabled ? 'admin' : 'disabled'
  }
}

// Store the first admin password as a Key Vault secret
resource secretAdminPassword1 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: keyVault
  name: adminCredentialsKeyVaultSecretUserPassword1
  properties: {
    value: containerRegistry.properties.adminUserEnabled ? 'password-placeholder-1' : 'disabled'
  }
}

// Store the second admin password as a Key Vault secret
resource secretAdminPassword2 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: keyVault
  name: adminCredentialsKeyVaultSecretUserPassword2
  properties: {
    value: containerRegistry.properties.adminUserEnabled ? 'password-placeholder-2' : 'disabled'
  }
}

output registryName string = containerRegistry.name
output keyVaultSecretsStored bool = true

