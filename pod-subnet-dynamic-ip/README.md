This config implements Pod Subnet [Dynamic IP allocation](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni-dynamic-ip-allocation#configure-networking-with-dynamic-allocation-of-ips-and-enhanced-subnet-support---azure-cli) by creating two subnets then assigning one as the node subnet and the other to pod subnet.

```
az deployment group create --resource-group acns-pm-demo --template-file main.bicep --mode Incremental
```