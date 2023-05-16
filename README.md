# Azure Virtual Desktop - Remove Expired Personal Session Hosts

This solution removes session hosts from a personal host pool based on a defined expiration in days. To ensure the session hosts have existed during that span of the time, the script first checks the creation date / time on the OS disk.  If the disk is older than the expiration time, then a query is run in a log analytics workspace to see if anyone has connected to the session host within the expiration time. If any connections were made, the session host is ignored. However, if no connections were made, the session host is removed from the host pool and the virtual machine is deleted.

The following resources are deployed in this solution:

* Action Group (Optional)
* Automation Account
  * Diagnostic Setting (Optional)
  * Job Schedule
  * Runbook
  * Schedule
* Host Pool Diagnostic Setting
* Log Analytics Workspace
* Resource Group
* Role Assignments
* Schedule Query Rules, aka Alerts (Optional)

## Prerequisites

The principal deploying this solution must be an Owner on the subscription.  This is required to successfully deploy the resources listed above.

## Deployment Options

### Azure Portal

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FRemoveExpiredAvdPersonalSessionHosts%2Fmain%2Fsolution.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FRemoveExpiredAvdPersonalSessionHosts%2Fmain%2FuiDefinition.json)
[![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FRemoveExpiredAvdPersonalSessionHosts%2Fmain%2Fsolution.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FRemoveExpiredAvdPersonalSessionHosts%2Fmain%2FuiDefinition.json)

### PowerShell

````powershell
New-AzDeployment `
    -Location '<Azure location>' `
    -TemplateFile 'https://raw.githubusercontent.com/jamasten/RemoveExpiredAvdPersonalSessionHosts/main/solution.json' `
    -Verbose
````

### Azure CLI

````cli
az deployment sub create \
    --location '<Azure location>' \
    --template-uri 'https://raw.githubusercontent.com/jamasten/RemoveExpiredAvdPersonalSessionHosts/main/solution.json'
````
