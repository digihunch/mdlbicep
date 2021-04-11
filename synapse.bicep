param location string = resourceGroup().location
param synapsePrefix string = 'synp'
param sqlPrefix string = 'sql'
param adls2url string
param adls2fs string

var synapseWorkspaceName = '${synapsePrefix}${uniqueString(resourceGroup().id)}'
var sqlPoolName = '${sqlPrefix}${uniqueString(resourceGroup().id)}'

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
  // the following firewall rule is not favourable. we put it in because: when child resource is declared outside of Synapse/workspaces resource, azure service (deployment) needs to access synapse service. The option of "Allow Azure services and resources to access this workspace" is available on console, but not represented in ARM template
  resource fwr 'firewallRules' = {
    name: 'synpfwrule-wideopen'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '255.255.255.255'
    }
  }
}

resource sqlp 'Microsoft.Synapse/workspaces/sqlPools@2021-03-01' = {
  name: '${synapseWorkspaceName}/${sqlPoolName}'
  location: location
  sku: {
    name: 'DW100c'
    capacity: 0
  }
}
