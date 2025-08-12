@description('The name of the Managed Cluster resource.')
param clusterName string = 'kubenet-test'

@description('The location of the Managed Cluster resource.')
param location string = 'westus2'

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string = 'acn-demo'

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 3

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

resource vnet1 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: '${clusterName}-cluster-net'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['192.168.0.0/16']
    }
    subnets: [
      {
        name: '${clusterName}-subnet'
        properties: {
          addressPrefix: '192.168.1.0/24'
        }
      }
    ]
  }
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  name: '${clusterName}-subnet'
  parent: vnet1
}

resource aks 'Microsoft.ContainerService/managedClusters@2025-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'nodepool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: subnet1.id
      }
    ]
    kubernetesVersion: '1.33'
    networkProfile: {
      networkPlugin: 'kubenet'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      podCidr: '10.244.0.0/16'
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
