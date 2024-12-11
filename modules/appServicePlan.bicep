@description('The name of the App Service Plan')
param name string

@description('The location for the App Service Plan')
param location string

@description('The pricing tier for the App Service Plan')
param skuName string = 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    capacity: 1
  }
}

output planName string = appServicePlan.name
