
## ACN Demo

This repo is used to quickly deploy use cases.

Workflow:

1. Setup infra pieces from Bicep (or Terraform) equivalent. Bicep is easier if using features from public preview.

   https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/change-log/managedclusters

2. Deploy application code. This can be done with a variety of tooling but the main focus will be through Helmfiles.

3. Create pipelines. TBD but most of the examples in this repo are stateless and should be easy to setup/teardown.

### Prerequisites

1. [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
1. [AZ CLI](https://learn.microsoft.com/en-us/cli/azure/)
1. A [resource group](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
