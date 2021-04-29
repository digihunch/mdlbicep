param deploySynapse bool = false
param deployADF bool = false

module adls2 './storage.bicep' = if (deployADF) {
  name: 'adls2Deploy'
}

module adf './adf.bicep' = if (deployADF) {
  name: 'ADFDeploy'
}

module dbr './databricks.bicep' = {
  name: 'DatabricksDeploy'
}

module synp './synapse.bicep' = if (deploySynapse) {
  name: 'synpDeploy'
  params: {
    adls2url: adls2.outputs.dlEndpoint
    adls2fs: adls2.outputs.fsname
  }
}

module aas './aas.bicep' = {
  name: 'AASDeploy'
}
