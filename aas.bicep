param namePrefix string = 'aas'
param ansvrname string
param location string = resourceGroup().location
var aasName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource aas 'Microsoft.AnalysisServices/servers@2017-08-01' = {
  name: ansvrname 
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 5
  }
  properties: {
    asAdministrators: {
      members: [
      ]
    }
  }
}
