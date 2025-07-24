@description('The name of the Managed Cluster resource.')
param clusterName string = 'acns-test'

@description('The location of the Managed Cluster resource.')
param location string = 'westus3'

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

resource aks 'Microsoft.ContainerService/managedClusters@2025-05-01' = {
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
      }
    ]
    kubernetesVersion: '1.32'
    networkProfile: {
      advancedNetworking: {
        enabled: true
      }
      ipFamilies: [
        'ipv4'
        'ipv6'
      ]
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      networkPolicy: 'cilium'
      networkDataplane: 'cilium'
      podCidr: '192.168.0.0/16'
      podCidrs: [
        '192.168.0.0/16'
      ]
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
