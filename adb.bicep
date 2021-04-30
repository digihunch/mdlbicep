param namePrefix string = 'adb'
var adbWorkspaceName = '${namePrefix}${uniqueString(resourceGroup().id)}'
@allowed([
  'standard'
  'premium'
])
param pricingTier string = 'premium'

param location string = resourceGroup().location

var managedResourceGroupName = 'databricks-rg-${adbWorkspaceName}-${uniqueString(adbWorkspaceName, resourceGroup().id)}'

resource ws 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: adbWorkspaceName
  location: location
  sku: {
    name: pricingTier
  }
  properties: {
    // TODO: improve once we have scoping functions
    managedResourceGroupId: '${subscription().id}/resourceGroups/${managedResourceGroupName}'
   // enableFedRampCertification: false
   // enableNoPublicIp: false
   // prepareEncryption: false
   // requireInfrastructureEncryption: true
    //storageAccountName
  }
}

output workspace object = ws
