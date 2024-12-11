@description('The location for all resources')
param location string

@description('The name of the Azure Container Registry')
param registryName string

@description('The name of the App Service Plan')
param appServicePlanName string

@description('The name of the Web App')
param webAppName string

module containerRegistry './modules/containerRegistry.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    name: 'myContainerRegistry' // Replace with your ACR name
    location: location
    adminCredentialsKeyVaultResourceId: keyVault.outputs.resourceId
    adminCredentialsKeyVaultSecretUserName: 'acr-admin-username'
    adminCredentialsKeyVaultSecretUserPassword1: 'acr-admin-password1'
    adminCredentialsKeyVaultSecretUserPassword2: 'acr-admin-password2'
  }
}


module appServicePlan './modules/appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName
    location: location
  }
}

module webApp './modules/webApp.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: webAppName
    location: location
    appServicePlanName: appServicePlan.outputs.planName
  }
}

module keyVault './modules/key-vault.bicep' = {
  name: 'keyVaultDeployment'
  params: {
    name: 'myKeyVault' // Replace with your Key Vault name
    location: location
    enableVaultForDeployment: true
    roleAssignments: [
      {
        principalId: 'c52bb0cc-7f22-4c28-aee8-264d1cafbb06'
        roleDefinitionIdOrName: 'Key Vault Secrets User'
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

