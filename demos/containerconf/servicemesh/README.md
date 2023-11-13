# Canary Rollout with Cilium

## Prerequisites

```shell
# Create namespace fred
kubectl --context aks-cilium-demo-01 create ns fred
kubectl --context aks-cilium-demo-02 create ns fred

# Create the Gateway
kubectl --context aks-cilium-demo-01 -n fred apply -f gateway.yaml

# Create Cert-Manager Issuer for namespace fred
kubectl --context aks-cilium-demo-01 -n fred apply -f issuer.yaml

# Install Fred application to namespace fred on cluster 01
kubectl --context aks-cilium-demo-01 -n fred apply -f cluster01-fred.yaml

# Install Fred v2 services on cluster 01
kubectl --context aks-cilium-demo-01 -n fred apply -f cluster01-fredv2.yaml

# Install Fred v2 app with API backend to namespace fred on cluster 02
kubectl --context aks-cilium-demo-02 -n fred apply -f cluster02-fredv2.yaml

# Add HTTPRoute
kubectl --context aks-cilium-demo-01 -n fred apply -f route.yaml
```

## Demo

```shell
# Adjust backend weights to distribute traffic to the services
kubectl --context aks-cilium-demo-01 -n fred apply -f route.yaml

# Access URL to verify traffic distribution
https://fred.demo.whiteduck.de/
```
