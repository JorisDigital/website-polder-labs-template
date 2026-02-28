param location string = resourceGroup().location
param name string
param branch string = 'main'
param repositoryUrl string = ''
@secure()
param repositoryToken string = ''
@allowed([
  'Enabled'
  'Disabled'
])
param stagingEnvironmentPolicy string = 'Disabled'
@allowed([
  'Free'
  'Standard'
])
param skuName string = 'Free'

var repoIntegrationProperties = empty(repositoryUrl)
  ? {}
  : {
      provider: 'GitHub'
      repositoryUrl: repositoryUrl
      repositoryToken: repositoryToken
      branch: branch
    }

resource staticWebApp 'Microsoft.Web/staticSites@2025-03-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    tier: skuName
  }
  properties: union(
    {
      stagingEnvironmentPolicy: stagingEnvironmentPolicy
      buildProperties: {
        skipGithubActionWorkflowGeneration: true
      }
    },
    repoIntegrationProperties
  )
}

output defaultHostname string = staticWebApp.properties.defaultHostname
