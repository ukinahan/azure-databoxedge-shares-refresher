Param(
  [string] $RoleName = 'azure-databoxedge-shares-refresher',
  [string] $Location = 'eastus',
  [string] $ServicePrincipalId
)

Function Get-RoleDefinitionId {
  az role definition list --name $RoleName --query '[0].name' -o tsv
}

$roleDefinitionId = Get-RoleDefinitionId

$timestamp = (Get-Date).ToString("yyyyMMddHHmmss")

if ($roleDefinitionId -eq "" ) {
  Write-Host "Custom Role Not Found, creating it"

  $deploymentName = "$timestamp-cr"
  az deployment sub create -n $deploymentName -l $Location --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/subscription-level-deployments/create-role-def/azuredeploy.json" --parameters roleName=$RoleName --parameters actions='["*/read", "Microsoft.DataBoxEdge/dataBoxEdgeDevices/shares/refresh/action"]'

  $roleDefinitionId = Get-RoleDefinitionId
} else {
  Write-Host "Custom Role Found, assigning $roleDefinitionId to $ServicePrincipalId"
}

$deploymentName = "$timestamp-ra"
az deployment sub create -n $deploymentName -l $Location --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/subscription-level-deployments/subscription-role-assigment/azuredeploy.json" --parameters principalId="$ServicePrincipalId" --parameters roleDefinitionId=$roleDefinitionId
