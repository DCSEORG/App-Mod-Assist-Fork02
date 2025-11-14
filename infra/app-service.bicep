// Azure App Service Bicep Template
// Deploy to UK South with low-cost development SKU

@description('Name of the App Service')
param appServiceName string = 'expense-mgmt-app-${uniqueString(resourceGroup().id)}'

@description('Location for all resources')
param location string = 'uksouth'

@description('App Service Plan SKU - using low cost development tier')
param appServicePlanSku string = 'F1'

@description('App Service Plan Tier')
param appServicePlanTier string = 'Free'

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${appServiceName}-plan'
  location: location
  sku: {
    name: appServicePlanSku
    tier: appServicePlanTier
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// App Service
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      alwaysOn: false
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
      ]
    }
  }
}

// Outputs
output appServiceUrl string = 'https://${appService.properties.defaultHostName}'
output appServiceName string = appService.name
output resourceGroupName string = resourceGroup().name
