param location string = resourceGroup().location
param synapsePrefix string = 'synp'
param sqlPrefix string = 'sql'
param sparkPrefix string = 'sk'
param adls2url string
param adls2fs string

var synapseWorkspaceName = '${synapsePrefix}${uniqueString(resourceGroup().id)}'
var sqlPoolName = '${sqlPrefix}${uniqueString(resourceGroup().id)}'
var sparkPoolName = '${sparkPrefix}${uniqueString(resourceGroup().id)}'

// 1. with synapse workspace, a firewall rule to wide open to all IPs is configured. Ideally, it should only open the Azure deployment service. The option of "Allow Azure services and resources to access this workspace" is available on console, but not represented in ARM template. This should be updated once such option becomes available.

// 2. even the firewall rule does not take effect immediately. Therefore it is not possible to delcare child resource afterwards due to error 'Parent resource xxx not found' when declaring child resource outside of parent resource afterwards. Therefore the declaration has to be made at the time of creating parent resource. 

resource synp 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: synapseWorkspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sqlAdministratorLogin: 'admin_khdsf892sj78q'
    managedVirtualNetwork: 'default'
    managedVirtualNetworkSettings: {
      preventDataExfiltration: false
    }
    defaultDataLakeStorage: {
      accountUrl: adls2url
      filesystem: adls2fs
    }
  }
  // it's not safe! but AllowAllWindowsAzureIps is not supported.
  resource fwr 'firewallRules' = {
    name: 'AllowAllIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '255.255.255.255'
    }
  }
  resource sqlp 'sqlPools' = {
    name: '${sqlPoolName}'
    location: location
    sku: {
      name: 'DW100c'
      capacity: 0
    }
  }

  resource spkp 'bigDataPools' = {
    name: '${sparkPoolName}'
    location: location
    properties: {
      sparkVersion: '2.4'
      nodeCount: 1
      nodeSize: 'Small'
      nodeSizeFamily: 'MemoryOptimized'
      autoPause: {
        delayInMinutes: 15
        enabled: true
      }
      autoScale: {
        enabled: true
        minNodeCount: 3
        maxNodeCount: 15
      }
      isComputeIsolationEnabled: false 
//      libraryRequirements: {
//        filename: 'requirements.txt'
//        content: 'azure-common>=1.1.1\r\nazure-core>=1.1.0\r\nazure-identity>=1.4.0\r\nazure-keyvault-secrets>=4.1.0'
//      }
      dynamicExecutorAllocation: {
        enabled: false
      }
      cacheSize: 0
      sessionLevelPackagesEnabled: true
    }
  }
}
