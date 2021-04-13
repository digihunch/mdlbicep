param location string = resourceGroup().location
param atmaccntname string = 'sqlpooladmin'
param atmsynpwsname string = 'devitanalyticssynpwtest'
param atmsqlpoolname string = 'devsynpsql01tst'

var rgname = resourceGroup().name
var srcrepname = 'runbooksrc'

/* Example to find out contentLink uri:
 $AzSynp = Find-Module Az.Synapse
 $uri=$AzSynp.RepositorySourceLocation + '/package/' + $AzSynp.Name
 $version=$AzSynp.Version
 
  Note, there might be dependencies between modules, for example, importing Az.Synapse requires Az.Accounts to be first imported so explicit dependency needs to be declared.
*/

resource atmmodacc 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${atmaccntname}/Az.Accounts'
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Accounts'
      version: '2.2.7'
    }
  }
}

resource atmmodsynp 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${atmaccntname}/Az.Synapse'
  dependsOn: [
    atmmodacc
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Synapse'
      version: '0.9.0'
    }
  }
}

resource atmvarrgname 'Microsoft.Automation/automationAccounts/variables@2020-01-13-preview' = {
  name: '${atmaccntname}/ResourceGroupName'
  properties: {
    isEncrypted: false 
    value: '"${resourceGroup().name}"'
  }
}

resource atmvarsqlpool 'Microsoft.Automation/automationAccounts/variables@2020-01-13-preview' = {
  name: '${atmaccntname}/SqlPoolName'
  properties: {
    isEncrypted: true
    value: '"${atmsqlpoolname}"'
  }
}

resource atmvarsynpws 'Microsoft.Automation/automationAccounts/variables@2020-01-13-preview' = {
  name: '${atmaccntname}/SynapseWorkspaceName'
  properties: {
    isEncrypted: true
    value: '"${atmsynpwsname}"'
  }
}

resource srcctrl 'Microsoft.Automation/automationAccounts/sourceControls@2020-01-13-preview' = {
  name: '${atmaccntname}/${srcrepname}'
  properties: {
    repoUrl: 'https://github.com/digihunch/admin-sqlpool.git'
    sourceType: 'GitHub'
    branch: 'main'
    folderPath: '/'
    autoSync: true
    publishRunbook: true
    securityToken: {
      accessToken: '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'
      refreshToken: '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' 
      tokenType: 'PersonalAccessToken'
    }
  }
}

// param startTimeStamp string = '04/30/2021 03:00:00-03:00'
param startTimeStamp string = dateTimeAdd(utcNow('MM/dd/yyyy'),'PT32H')
resource loadschedule 'Microsoft.Automation/automationAccounts/schedules@2019-06-01' = {
  name: '${atmaccntname}/loadschedule'
  properties: {
    startTime: '${startTimeStamp}'
    interval: 1
    frequency: 'Day'
    timeZone: 'America/Chicago'
  }
}


resource synpws 'Microsoft.Synapse/workspaces@2020-12-01' existing = {
  name: atmsynpwsname 
}

resource sqlpool 'Microsoft.Synapse/workspaces/sqlPools@2020-12-01' existing = {
  name: atmsqlpoolname 
}

resource lowsqlalert 'microsoft.insights/metricAlerts@2018-03-01' = {
  name: 'LowUsageAlert'
  location: 'global'
  dependsOn: [
    synpws
    sqlpool 
  ]
  properties: {
    description: 'No user queries against sql pool.'
    severity: 3
    enabled: true
    scopes: [
      synpws.id
      sqlpool.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT1H'
    criteria: {
      allOf: [
        {
          threshold: 1
          name: 'Metric1'
          metricNamespace: 'microsoft.synapse/workspaces/sqlpools'
          metricName: 'ActiveQueries'
          operator 'LessThan'
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion' 
        }
      ]
      odata.type: 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
  }
}
