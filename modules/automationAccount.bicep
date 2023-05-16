param AutomationAccountName string
param EnableAlerts bool
param HostPoolName string
param HostPoolResourceGroupName string
param JobScheduleName string = newGuid()
param Location string
param LogAnalyticsWorkspaceResourceId string
param RunbookName string
param SessionHostExpirationInDays int
param Tags object
param Time string = utcNow('u')
param TimeZone string
param WorkspaceId string

resource automationAccount 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: AutomationAccountName
  location: Location
  tags: Tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

resource diagnosticsSetting 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if(EnableAlerts) {
  scope: automationAccount
  name: 'diag-${automationAccount.name}'
  properties: {
    logs: [
      {
        category: 'JobLogs'
        enabled: true
      }
      {
        category: 'JobStreams'
        enabled: true
      }
    ]
    workspaceId: LogAnalyticsWorkspaceResourceId
  }
}

resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2019-06-01' = {
  parent: automationAccount
  name: RunbookName
  location: Location
  tags: Tags
  properties: {
    runbookType: 'PowerShell'
    logProgress: false
    logVerbose: false
    publishContentLink: {
      uri: 'https://raw.githubusercontent.com/jamasten/RemoveExpiredAvdPersonalSessionHosts/main/artifacts/Remove-StaleHosts.ps1'
      version: '1.0.0.0'
    }
  }
}

resource schedule 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: runbook.name
  properties: {
    frequency: 'Day'
    interval: 1
    startTime: dateTimeAdd(Time, 'PT15M')
    timeZone: TimeZone
  }
}

resource jobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
  parent: automationAccount
  #disable-next-line use-stable-resource-identifiers
  name: JobScheduleName
  properties: {
    parameters: {
      EnvironmentName: environment().name
      HostPoolName: HostPoolName
      HostPoolResourceGroupName: HostPoolResourceGroupName
      SessionHostExpirationInDays: string(SessionHostExpirationInDays)
      SubscriptionId: subscription().subscriptionId
      TenantId: subscription().tenantId
      WorkspaceId: WorkspaceId
    }
    runbook: {
      name: runbook.name
    }
    schedule: {
      name: schedule.name
    }
  }
}

output principalId string = automationAccount.identity.principalId
