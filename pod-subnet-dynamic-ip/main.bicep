@description('The name of the Managed Cluster resource.')
param clusterName string = 'bicep-test'

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

resource vnet1 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: '${clusterName}-cluster-net'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/8']
    }
    subnets: [
      {
        name: '${clusterName}-node-subnet-1'
        properties: {
          addressPrefix: '10.240.0.0/16'
        }
      }
      {
        name: '${clusterName}-node-subnet-2'
        properties: {
          addressPrefix: '10.241.0.0/16'
        }
      }
    ]
  }
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' existing = {
  name: '${clusterName}-node-subnet-1'
  parent: vnet1
}

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' existing = {
  name: '${clusterName}-node-subnet-2'
  parent: vnet1
}

resource aks 'Microsoft.ContainerService/managedClusters@2025-09-01' = {
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
        podSubnetID: subnet2.id
      }
    ]
    kubernetesVersion: '1.33'
    networkProfile: {
      networkPlugin: 'azure'
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
