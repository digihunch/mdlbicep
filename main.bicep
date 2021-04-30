param deploySynapse bool = true
//param deployADF bool = true
//param deployADB bool = true
param deployAAS bool = true

module adls2 './storage.bicep' = if (deployADF) {
  name: 'adls2Deploy'
}

/*
module adf './adf.bicep' = if (deployADF) {
  name: 'adfDeploy'
}

module adb './adb.bicep' = if (deployADB) {
  name: 'adbDeploy'
  params: {
    pricingTier: 'premium'    
  }
}
*/

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
    ansvrname: 'servicename'
  }
}

