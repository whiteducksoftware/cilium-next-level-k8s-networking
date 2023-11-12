# Cluster Mesh

## Prerequisites

```shell
# Create rebels namespace in both clusters
kubectl --context aks-cilium-demo-01 create ns rebels
kubectl --context aks-cilium-demo-02 create ns rebels

# Connect to cluster01 and apply the following manifest
kubectl --context aks-cilium-demo-02 apply -n rebels \
  -f https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/clustermesh/global-service-example/cluster1.yaml

# Connect to cluster02 and apply the following manifest
kubectl --context aks-cilium-demo-02 apply -n rebels \
  -f https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/clustermesh/global-service-example/cluster2.yaml
```

## Demo: Global Service

```shell
# connect to the rebel-base
kubectl --context aks-cilium-demo-01 -n rebels exec  x-wing-669699586f-9trng -- curl -s rebel-base.rebels.svc.cluster.local/index.html
kubectl --context aks-cilium-demo-02 -n rebels exec  x-wing-669699586f-7t2q9 -- curl -s rebel-base.rebels.svc.cluster.local/index.html

# Scale down the x-wing deployment
kubectl --context aks-cilium-demo-01 -n rebels scale deployment rebel-base --replicas 0

# Connect to the rebel-base again
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-669699586f-9trng -- curl -s rebel-base.rebels.svc.cluster.local/index.html
```

## Bonus: Cluster Mesh Network Policy

```shell
# Connect to Cluster02 and apply the deny-all policy
kubectl --context aks-cilium-demo-02 -n rebels apply -f deny-all.yaml

# Inspect network policy
kubectl --context aks-cilium-demo-01 -n rebels get ciliumnetworkpolicies.cilium.io rebel-default-deny -o yaml | yq

# Try contact the rebel-base again
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-669699586f-9trng -- curl -s rebel-base.rebels.svc.cluster.local/index.html

# Apply the allow policy in Cluster02
kubectl --context aks-cilium-demo-02 -n rebels apply -f allow-cross-cluster.yaml

# Inspect network policy
kubectl --context aks-cilium-demo-01 -n rebels get ciliumnetworkpolicies.cilium.io allow-cross-cluster -o yaml | yq

# Contact the rebel-base again
kubectl --context aks-cilium-demo-01 -n rebels exec x-wing-669699586f-9trng -- curl -s rebel-base.rebels.svc.cluster.local/index.html
```
