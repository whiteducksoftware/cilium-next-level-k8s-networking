# Cilium & AKS Workshop Day

This repository contains the material for our Next-level Kubernetes networking ​with Cilium talk.

## Slides

The slides are available [here](./next-level-k8s-networking-with-cilium.pdf).

## Prerequisites

```shell
# Create 2 AKS clusters with no CNI (BYOCNI)
cd ./src

# Login to Azure
az login
az account set --subscription <SUBSCRIPTION_ID>

# Execute Terraform
terraform init
terraform apply -auto-approve

# Install Cilium on AKS with BYOCNI
# Connect to cluster 01

az aks get-credentials --resource-group rg-cilium-demo --name aks-cilium-demo-01

# Install Cilium on cluster 01
cilium install \
    --datapath-mode aks-byocni \
    --set azure.resourceGroup="rg-cilium-demo" \
    --set cluster.id=1 \
    --set cluster.name=aks-cilium-demo-01 \
    --set ipam.operator.clusterPoolIPv4PodCIDRList='{10.10.0.0/16}' \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set kubeProxyReplacement=strict \
    --set gatewayAPI.enabled=true

# Connect to cluster 02
az aks get-credentials --resource-group rg-cilium-demo --name aks-cilium-demo-02
cd
# Install Cilium on cluster 02
cilium install \
    --datapath-mode aks-byocni \
    --set azure.resourceGroup="rg-cilium-demo" \
    --set cluster.id=2 \
    --set cluster.name=aks-cilium-demo-02 \
    --set ipam.operator.clusterPoolIPv4PodCIDRList='{10.20.0.0/16}' \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set kubeProxyReplacement=strict \
    --set gatewayAPI.enabled=true
```

## Demo: Hubble in action

Find all details [here](demos/hubble/README.md).

## Demo: Canary Rollout with Cilium

Find all details [here](demos/servicemesh/README.md).
