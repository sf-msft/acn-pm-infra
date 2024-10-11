@description('The name of the Managed Cluster resource.')
param clusterName1 string = 'byo-cilium-1'
param clusterName2 string = 'byo-cilium-2'

@description('The location of the Managed Cluster resource.')
param location1 string = 'westus3'
param location2 string = 'westus2'

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


resource vnet1 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: '${clusterName1}-cluster-net'
  location: location1
  properties: {
    addressSpace: {
      addressPrefixes: ['192.168.10.0/24']
    }
    subnets: [
      {
        name: '${clusterName1}-node-subnet'
        properties: {
          addressPrefix: '192.168.10.0/24'
        }
      }
    ]
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: '${clusterName2}-cluster-net'
  location: location2
  properties: {
    addressSpace: {
      addressPrefixes: ['192.168.20.0/24']
    }
    subnets: [
      {
        name: '${clusterName2}-node-subnet'
        properties: {
          addressPrefix: '192.168.20.0/24'
        }
      }
    ]
  }
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  name: '${clusterName1}-node-subnet'
  parent: vnet1
}

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  name: '${clusterName2}-node-subnet'
  parent: vnet2
}

resource cluster1 'Microsoft.ContainerService/managedClusters@2024-06-02-preview' = {
  name: clusterName1
  location: location1
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
        vnetSubnetID: subnet1.id // Needs vnet created before assigning subnet
      }
    ]
    networkProfile: {
      networkPlugin: 'none'
      podCidr: '10.10.0.0/16'
      serviceCidr: '10.11.0.0/16'
      dnsServiceIP: '10.11.0.10'
    }
  }
}

resource cluster2 'Microsoft.ContainerService/managedClusters@2024-06-02-preview' = {
  name: clusterName2
  location: location2
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
        vnetSubnetID: subnet2.id // Needs vnet created before assigning subnet
      }
    ]
    networkProfile: {
      networkPlugin: 'none'
      podCidr: '10.20.0.0/16'
      serviceCidr: '10.21.0.0/16'
      dnsServiceIP: '10.21.0.10'
    }
  }
}

resource peering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: 'peering-${clusterName1}-to-${clusterName2}'
  parent: vnet1
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

resource peering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: 'peering-${clusterName2}-to-${clusterName1}'
  parent: vnet2
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}
