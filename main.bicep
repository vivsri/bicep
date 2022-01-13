@allowed([
  'dev'
  'prod'
])
param env string = 'dev'
param clientcode string = 'toys999'
param region string = 'we'
param location string = resourceGroup().location
param storageaccountname string = '${clientcode}${region}${env}bicepstore'
param appservicename string = '${clientcode}${region}${env}bicepappservice'
param appserviceplanname string = '${clientcode}${region}${env}bicepappserviceplan'

var storageaccountskuname = (env == 'dev') ? 'Standard_LRS' : 'Standard_GRS'
/*var appserviceplanskuname = (env == 'dev') ? 'F1' : 'P1V2'
output appserviceurl string = webApplication.properties.defaultHostName
output appserviceoutbundIP string = webApplication.properties.outboundIpAddresses*/

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageaccountname
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageaccountskuname
  }
}
/*resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appserviceplanname
  location: location
  sku: {
    name: appservceplanskuname
    capacity: 1
  }
}
resource webApplication 'Microsoft.Web/sites@2018-11-01' = {
  name: appservicename
  location: location
    properties: {
    serverFarmId: appServicePlan.id
    httpsOnly:true
  }
}*/
module appservice 'modules/appservice.bicep' = {
  name: 'appservice'
  params: {
    location: location
    appservicename: appservicename
    appserviceplanname: appserviceplanname
  }
}
output appserviceurl string = appservice.outputs.appserviceurl
output appserviceoutbundIP string = appservice.outputs.appserviceoutbundIP
