@description('The name of the Managed Cluster resource.')
param clusterName string = 'pod-cidr-test'

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

resource aks 'Microsoft.ContainerService/managedClusters@2025-10-02-preview' = {
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
        osSKU: 'Ubuntu2404'
        mode: 'System'
      }
    ]
    kubernetesVersion: '1.33'
    networkProfile: {
      advancedNetworking: {
        enabled: true
        security: {
          enabled: false
        }
        observability: {
          enabled: false
        }
        performance: {
          accelerationMode: 'BpfVeth'
        }
      }
      ipFamilies: [
        'ipv4'
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
