param namePrefix string = 'adf'
param location string = resourceGroup().location
var ADFInstName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource adf 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: ADFInstName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

