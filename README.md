# Azure Static Web App with Front Door
## Deploying using Bicep
Using bash
```
git clone https://github.com/rukasakurai/staticwebappwithfrontdoor
cd staticwebappwithfrontdoor
```
```
RG=<ResourceGroupName>
LOCATION="japaneast"
az account set --subscription <SubscriptionID>
az group create --name $RG --location $LOCATION
az deployment group create --resource-group $RG --template-file main.bicep
```
Get the endpoint URL from the Azure Portal, and test it. It may take a few minutes until the expected page is displayed without error.
## Create GitHub Action to deploy code
It would be nice if the Bicep deployment also created a GitHub Action, but it seems like it doesnt.
So to create a new GitHub Action workflow by going to the Actions tab, selecting "New workflow" > "Deploy web app to Azure Static Web Apps". And set the appropriate token by following: https://docs.microsoft.com/en-us/azure/static-web-apps/deployment-token-management
Get the endpoint URL from the Azure Portal, and test it. It may take a few minutes until the expected page is displayed without error.

The above steps do not create a GitHub Actions workflow to deploy the static contents to the newly deployed Static Web App.
## Tips
Microsoft Learn for Bicep beginners: https://docs.microsoft.com/learn/modules/build-first-bicep-template/
Bicep template samples for Front Door: https://docs.microsoft.com/azure/frontdoor/front-door-quickstart-template-samples
Creating a Bicep template from an existing resource group: https://docs.microsoft.com/azure-resource-manager/bicep/decompile?tabs=azure-cli#export-template-and-convert
