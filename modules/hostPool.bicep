param HostPoolName string
param LogAnalyticsWorkspaceResourceId string

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2021-07-12' existing = {
  name: HostPoolName
}

resource hostPoolDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${HostPoolName}'
  scope: hostPool
  properties: {
    logs: [
      {
        category: 'Connection'
        enabled: true
      }
    ]
    workspaceId: LogAnalyticsWorkspaceResourceId
  }
}
