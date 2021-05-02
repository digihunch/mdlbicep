param deploySynapse bool = true
param deployAAS bool = true

module adls2 './storage.bicep' = {
  name: 'adls2Deploy'
}

module synp './synapse.bicep' = if (deploySynapse) {
  name: 'synpDeploy'
  params: {
    adls2url: adls2.outputs.dlEndpoint
    adls2fs: adls2.outputs.fsname
  }
}

module aas './aas.bicep' = if (deployAAS) {
  name: 'aasDeploy'
  params: {
  }
}

