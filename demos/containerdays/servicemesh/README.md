# Canary Rollout with Cilium

## Prerequisites

```shell
# Create namespace fred
kubectl create ns fred

# Install Fred application to namespace fred on cluster 01
kubectl apply -f ./files/cluster01-fred.yaml --context aks-cilium-demo-01

# Install Fred v2 services on cluster 01
kubectl apply -f ./files/cluster01-fredv2.yaml --context aks-cilium-demo-01

# Install Fred v2 app with API backend to namespace fred on cluster 02
kubectl apply -f ./files/cluster02-fredv2.yaml --context aks-cilium-demo-02

# Install Gateway API config
kubectl apply -f ./files/gateway.yaml --context aks-cilium-demo-01
```

## Demo

```shell
# Adjust backend weights to distribute traffic to the services
kubectl apply -f gateway.yaml --context aks-cilium-demo-01

# Access URL to verify traffic distribution
http://fred.philipwelz.com/
```
