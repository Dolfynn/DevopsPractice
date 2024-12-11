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
    name: registryName
    location: location
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

