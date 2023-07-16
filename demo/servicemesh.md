# Canary Rollout with Cilium

## Prerequisites

```shell
# Enable Cluster Mesh on each Cluster
cilium clustermesh enable
cilium clustermesh status
# Connect the Clusters, only one direction is required
# From cluster 1 to cluster 2
cilium clustermesh connect --destination-context aks-cilium-demo-02
# Install Fred app to namespace fred
kubectl apply -f ./files/cluster01-fred.yaml --context aks-cilium-demo-01
# Install Fred v2 Services on Cluster 01
kubectl apply -f ./files/cluster01-fredv2.yaml --context aks-cilium-demo-01
# Install Fred v2 app with API Backend to namespace fred on Cluster 02
kubectl apply -f ./files/cluster02-fredv2.yaml --context aks-cilium-demo-02
# Install Gateway API config
kubectl apply -f ./files/gateway.yaml --context aks-cilium-demo-01
```

## Demo

```shell
# Adjust backend weights to distribute traffic to the services
kubectl apply -f ./files/gateway.yaml --context aks-cilium-demo-01
# Access URL to verify traffic distribution
http://fred.philipwelz.com/
```
