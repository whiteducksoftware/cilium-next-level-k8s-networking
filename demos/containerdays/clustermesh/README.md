# Cluster Mesh

## Prerequisites

```shell
# Create rebels namespace in both clusters
kubectl create ns rebels

# Set demo as rebels namespace
kubectl config set-context --current --namespace=rebels

# Connect to cluster01 and apply the following manifest
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/clustermesh/global-service-example/cluster1.yaml

# Connect to cluster02 and apply the following manifest
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/clustermesh/global-service-example/cluster2.yaml
```

## Demo: Global Service

```shell
# Connect to Cluster01 and connect to the rebel-base
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-7989c68c5c-9p4bj -- curl -s rebel-base.rebels.svc.cluster.local/index.html

# Scale down the x-wing deployment
kubectl --context aks-cilium-demo-01 -n rebels scale deployment rebel-base --replicas 0

# Connect to the rebel-base again
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-7989c68c5c-9p4bj -- curl -s rebel-base.rebels.svc.cluster.local/index.html
```

## Bonus: Cluster Mesh Network Policy

```shell
# Connect to Cluster02 and apply the deny-all policy
kubectl --context aks-cilium-demo-02 -n rebels apply -f deny-all.yaml

# Try contact the rebel-base again
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-7989c68c5c-9p4bj -- curl -s rebel-base.rebels.svc.cluster.local/index.html

# Apply the allow policy in Cluster02
kubectl --context aks-cilium-demo-02 -n rebels apply -f allow-cross-cluster.yaml

# Contact the rebel-base again
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-7989c68c5c-9p4bj -- curl -s rebel-base.rebels.svc.cluster.local/index.html
```
