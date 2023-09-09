# Canary Rollout with Cilium

## Prerequisites

```shell
# Create namespace fred
kubectl create ns fred --context aks-cilium-demo-01
kubectl create ns fred --context aks-cilium-demo-02

# Set fred as default namespace
kubectl config set-context --current --namespace=fred

# Create the Gateway
kubectl apply -f gateway.yaml --context aks-cilium-demo-01

# Install Fred application to namespace fred on cluster 01
kubectl apply -f cluster01-fred.yaml --context aks-cilium-demo-01

# Install Fred v2 services on cluster 01
kubectl apply -f cluster01-fredv2.yaml --context aks-cilium-demo-01

# Install Fred v2 app with API backend to namespace fred on cluster 02
kubectl apply -f cluster02-fredv2.yaml --context aks-cilium-demo-02

# Add HTTPRoute
kubectl apply -f route.yaml --context aks-cilium-demo-01
```

## Demo

```shell
# Adjust backend weights to distribute traffic to the services
kubectl apply -f route.yaml --context aks-cilium-demo-01

# Access URL to verify traffic distribution
http://fred.philipwelz.com/
```
