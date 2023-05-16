param Location string
param LogAnalyticsWorkspaceName string
param SessionHostExpirationInDays int
param Tags object

// 30 days is the minimum number of days to retain data
// Adding an extra day to the session host expiration value to ensure last minute logins are captured before removal
var LogAnalyticsWorkspaceRetention = SessionHostExpirationInDays < 30 ? 30 : (SessionHostExpirationInDays + 1)

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: LogAnalyticsWorkspaceName
  location: Location
  tags: Tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: LogAnalyticsWorkspaceRetention
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output resourceId string = logAnalyticsWorkspace.id
output workspaceId string = logAnalyticsWorkspace.properties.customerId
