#!/bin/bash
set -euxo pipefail

export CLUSTER1="byo-cilium-1"
export CLUSTER2="byo-cilium-2"
export AZURE_RESOURCE_GROUP="acns-pm-demo"

az aks get-credentials --resource-group acns-pm-demo --name $CLUSTER1 --overwrite-existing
az aks get-credentials --resource-group acns-pm-demo --name $CLUSTER2 --overwrite-existing

cilium install --set cluster.name=$CLUSTER1 --set cluster.id=1 --context $CLUSTER1 --set azure.resourceGroup="${AZURE_RESOURCE_GROUP}"
cilium install --set cluster.name=$CLUSTER2 --set cluster.id=2 --context $CLUSTER2 --set azure.resourceGroup="${AZURE_RESOURCE_GROUP}"

cilium status --wait --context $CLUSTER1
cilium status --wait --context $CLUSTER2

# Share Hubble Relay across clusters
# kubectl --context=$CLUSTER1 get secret -n kube-system cilium-ca -o yaml | \
#   kubectl --context $CLUSTER2 create -f -

cilium clustermesh enable --context $CLUSTER1 --service-type NodePort
cilium clustermesh enable --context $CLUSTER2 --service-type NodePort

cilium clustermesh status --context $CLUSTER1 --wait
cilium clustermesh status --context $CLUSTER2 --wait

cilium clustermesh connect --context $CLUSTER1 --destination-context $CLUSTER2