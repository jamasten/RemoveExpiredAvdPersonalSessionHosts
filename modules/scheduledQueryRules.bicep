param ActionGroupResourceId string
param Location string
param LogAnalyticsWorkspaceResourceId string
param Tags object

var Alerts = [
  {
    name: 'Remove Expired AVD Session Hosts - Failure'
    description: 'Sends an error alert when the runbook fails to execute.'
    severity: 0
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          query: 'AzureDiagnostics\n| where ResourceProvider == "MICROSOFT.AUTOMATION"\n| where Category  == "JobStreams"\n| where ResultDescription has "Failed to remove session hosts"'
          timeAggregation: 'Count'
          dimensions: [
            {
              name: 'ResultDescription'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          operator: 'GreaterThanOrEqual'
          threshold: 1
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
  }
  {
    name: 'Remove Expired AVD Session Hosts - Success'
    description: 'Sends an informational alert when AVD session hosts are removed.'
    severity: 3
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          query: 'AzureDiagnostics\n| where ResourceProvider == "MICROSOFT.AUTOMATION"\n| where Category  == "JobStreams"\n| where ResultDescription has "Removed session host"'
          timeAggregation: 'Count'
          dimensions: [
            {
              name: 'ResultDescription'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          operator: 'GreaterThanOrEqual'
          threshold: 1
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
  }
]

resource scheduledQueryRules 'Microsoft.Insights/scheduledQueryRules@2022-06-15' = [for i in range(0, length(Alerts)): {
  name: Alerts[i].name
  location: Location
  tags: Tags
  kind: 'LogAlert'
  properties: {
    actions: {
      actionGroups: [
        ActionGroupResourceId
      ]
    }
    autoMitigate: false
    skipQueryValidation: false
    criteria: Alerts[i].criteria
    description: Alerts[i].description
    displayName: Alerts[i].name
    enabled: true
    evaluationFrequency: Alerts[i].evaluationFrequency
    severity: Alerts[i].severity
    windowSize: Alerts[i].windowSize
    scopes: [
      LogAnalyticsWorkspaceResourceId
    ]
  }
}]
