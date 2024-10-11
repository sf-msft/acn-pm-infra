## Cilium Service Mesh on BYO CNI

Create the two clusters along with vNets setup for peering via Bicep:

```
az aks get-credentials --resource-group acns-pm-demo --name byo-cilium-1 --overwrite-existing
```

> Note: This is a case of resource dependency where agent pools require a subnet ID.

Since the network plugin is `none`, the nodes will appear in a not ready state even after the cluster is up.

```
NAME                               STATUS     ROLES    AGE     VERSION
aks-nodepool-24446851-vmss000000   NotReady   <none>   8m51s   v1.29.8
aks-nodepool-24446851-vmss000001   NotReady   <none>   9m19s   v1.29.8
aks-nodepool-24446851-vmss000002   NotReady   <none>   9m7s    v1.29.8
```

Then run `./install-cilium.sh` for setting up cluster mesh.
