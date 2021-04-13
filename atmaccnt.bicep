param location string = resourceGroup().location
// runas account cannot be created in ARM template. An ugly workaround:
// https://dev.to/omiossec/runas-account-in-azure-automation-arm-template-and-deployment-script-56n8

resource atmaccnt 'Microsoft.Automation/AutomationAccounts@2019-06-01' = {
  name: 'sqladminauto'
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}
