param location string = resourceGroup().location
param synapsePrefix string = 'synp'
param sqlPrefix string = 'sql'
param adls2url string
param adls2fs string

var synapseWorkspaceName = '${synapsePrefix}${uniqueString(resourceGroup().id)}'
var sqlPoolName = '${sqlPrefix}${uniqueString(resourceGroup().id)}'

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
  resource fwr 'firewallRules' = {
    name: 'synpfwrule-wideopen'
    properties: {
      // remove in the future
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
}
