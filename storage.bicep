param location string = resourceGroup().location
param namePrefix string = 'stg'

param globalRedundancy bool = true // defaults to true, but can be overridden

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
var containerName = 'analytics'

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS' // if true --> GRS, else --> LRS
  }
  properties: {
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
  }

}

resource adls2ctnr 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg.name}/default/${containerName}'
}

// how to delcare child resource https://github.com/Azure/bicep/issues/127#issuecomment-802861043

output storageId string = stg.id // replacement for resourceId(...)
output computedStorageName string = stg.name
output dlEndpoint string = stg.properties.primaryEndpoints.dfs // replacement for reference(...).*
output fsname string = containerName
