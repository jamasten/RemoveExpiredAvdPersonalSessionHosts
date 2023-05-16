param ActionGroupName string
param DistributionGroup string
param Tags object

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: ActionGroupName
  location: 'global'
  tags: Tags
  properties: {
    emailReceivers: [
      {
        emailAddress: DistributionGroup
        name: DistributionGroup
        useCommonAlertSchema: true
      }
    ]
    enabled: true
    groupShortName: 'AVD MGMT'
  }
}

output resourceId string = actionGroup.id
