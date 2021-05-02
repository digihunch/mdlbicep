param namePrefix string = 'aas'
param location string = resourceGroup().location
var aasName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource aas 'Microsoft.AnalysisServices/servers@2017-08-01' = {
  name: aasName 
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    asAdministrators: {
      members: [
      ]
    }
  }
}
