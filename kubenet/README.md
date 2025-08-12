# Kubenet

This example creates an AKS cluster using kubenet with the following equivalent CLI flags:

```
az aks create --resource-group myResourceGroup --name myAKSCluster --network-plugin kubenet --service-cidr 10.0.0.0/16 --dns-service-ip 10.0.0.10 --pod-cidr 10.244.0.0/16 --vnet-subnet-id $SUBNET_ID --generate-ssh-keys
```

Create the cluster using `Incremental` mode to ensure idempotency.
```
az deployment group create --resource-group acn-pm --template-file main.bicep --mode Incremental
```
