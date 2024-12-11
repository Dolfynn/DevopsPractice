@description('The name of the Web App')
param name string

@description('The location for the Web App')
param location string

@description('The App Service Plan for the Web App')
param appServicePlanName string

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: appServicePlanName
  }
}

output webAppName string = webApp.name
