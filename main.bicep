param profiles_profilename_name string
param staticSites_swa_name string
param endpointname string

resource profiles_profilename_name_resource 'Microsoft.Cdn/profiles@2021-06-01' = {
  kind: 'frontdoor'
  location: 'Global'
  name: profiles_profilename_name
  properties: {
    originResponseTimeoutSeconds: 60
  }
  sku: {
    name: 'Premium_AzureFrontDoor'
  }
}

resource staticSites_swa_name_resource 'Microsoft.Web/staticSites@2021-03-01' = {
  location: 'Central US'
  name: staticSites_swa_name
  properties: {
    allowConfigFileUpdates: true
    branch: 'master'
    enterpriseGradeCdnStatus: 'Disabled'
    provider: 'GitHub'
    repositoryUrl: 'https://github.com/rukasakurai/staticwebappwithfrontdoor'
    stagingEnvironmentPolicy: 'Enabled'
  }
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource profiles_profilename_name_endpointname 'Microsoft.Cdn/profiles/afdendpoints@2021-06-01' = {
  parent: profiles_profilename_name_resource
  location: 'Global'
  name: endpointname
  properties: {
    enabledState: 'Enabled'
  }
}

resource profiles_profilename_name_staticwebapp 'Microsoft.Cdn/profiles/origingroups@2021-06-01' = {
  parent: profiles_profilename_name_resource
  name: 'staticwebapp'
  properties: {
    healthProbeSettings: {
      probeIntervalInSeconds: 100
      probePath: '/'
      probeProtocol: 'Http'
      probeRequestType: 'HEAD'
    }
    loadBalancingSettings: {
      additionalLatencyInMilliseconds: 50
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    sessionAffinityState: 'Disabled'
  }
}

resource profiles_profilename_name_staticwebapp_staticwebapp 'Microsoft.Cdn/profiles/origingroups/origins@2021-06-01' = {
  parent: profiles_profilename_name_staticwebapp
  name: 'staticwebapp'
  properties: {
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
    hostName: staticSites_swa_name_resource.properties.defaultHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: staticSites_swa_name_resource.properties.defaultHostName
    priority: 1
    weight: 1000
  }
  dependsOn: [
    profiles_profilename_name_resource
  ]
}

resource profiles_profilename_name_endpointname_default_route 'Microsoft.Cdn/profiles/afdendpoints/routes@2021-06-01' = {
  parent: profiles_profilename_name_endpointname
  name: 'default-route'
  properties: {
    customDomains: []
    enabledState: 'Enabled'
    forwardingProtocol: 'MatchRequest'
    httpsRedirect: 'Enabled'
    linkToDefaultDomain: 'Enabled'
    originGroup: {
      id: profiles_profilename_name_staticwebapp.id
    }
    patternsToMatch: [
      '/*'
    ]
    ruleSets: []
    supportedProtocols: [
      'Http'
      'Https'
    ]
  }
  dependsOn: [
    profiles_profilename_name_resource
  ]
}