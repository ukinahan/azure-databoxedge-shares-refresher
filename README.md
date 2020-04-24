# Overview

Use an Azure Logic App to refresh all your Data Box Edge shares

## Prerequisites

To execute successfully the workflow in this repository you will need the following secrets:

- **AZURE_CREDENTIALS**: A JSON object with the credentials to connect to Azure and permissions to perform deployments at the subscription level
- **SERVICE_PRINCIPAL_OBJECT_ID**: The ObjectId of a Service Principal that will be used for granting role and access to operations against the ARM API
- **SERVICE_PRINCIPAL_APP_ID**: The AppId of a Service Principal that will be used for the connection to the ARM API used in the Logic App
- **SERVICE_PRINCIPAL_SECRET**: The secret of the Service Principal above.

See <https://github.com/Azure/login#configure-azure-credentials> for details on how to generate the Azure Credentials.

You can use the following command to create the Service Principal and see all the properties:

```bash
az ad sp create-for-rbac -n "http://azure-databoxedge-share-refresher" --skip-assignment
az ad sp show --id "http://azure-databoxedge-share-refresher"
```

## Template

The workflow file takes advantage of existing public templates and the Azure CLI to deploy at the Subscription level the following:

- A custom role definition
- Role assignment to a Service Principal

The last step is to perform a resource group deployment using template in the repository which creates:

- API Connection the ARM Managed API
- Logic App that will find all resources with a given tag and perform a refresh action on a commonly named share

## References

<https://vincentlauzon.com/2018/09/25/service-principal-for-logic-app-connector/>
