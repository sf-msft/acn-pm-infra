## Advanced Container Networking Services

This example demonstrates how to create an AKS cluster equivalent with the following flags:

`--network-plugin azure --network-plugin-mode overlay --pod-cidr 192.168.0.0/16 --network-dataplane cilium --enable-acns`

Create the cluster using `Incremental` mode to ensure idempotency when toggling ACNS features.

```
az deployment group create --resource-group acns-pm-demo --template-file main.bicep --mode Incremental
```
