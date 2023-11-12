# Cilium Next Level K8s Networking

This repository contains the material for our Next-level Kubernetes networking ​with Cilium talk.

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

# Install Gateway API CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/main/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml

# Install Cert-Manager
helm upgrade \
  --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set "extraArgs={--feature-gates=ExperimentalGatewayAPISupport=true}" \
  --set installCRDs=true

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

# Install Cilium on cluster 02
cilium install \
    --datapath-mode aks-byocni \
    --set azure.resourceGroup="rg-cilium-demo" \
    --set cluster.id=2 \
    --set cluster.name=aks-cilium-demo-02 \
    --set ipam.operator.clusterPoolIPv4PodCIDRList='{10.20.0.0/16}' \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set kubeProxyReplacement=strict

# Enable Cluster Mesh on each cluster
cilium clustermesh enable
cilium clustermesh status

# Connect the clusters, only one direction is required
# From cluster 01 to cluster 02 for example
cilium clustermesh connect --destination-context aks-cilium-demo-02
```

## KCD Munich 2023

### Slides

The slides are available [here](demos/kcd_munich/h/next-level-k8s-networking-with-cilium.pdf).

### Demo: Hubble in action

Find all details [here](demos/kcd_munich/hubble/README.md).

### Demo: Canary Rollout with Cilium

Find all details [here](demos/kcd_munich/servicemesh/README.md).

## ContainerDays 2023

### Slides

The slides are available [here](demos/containerdays/cds23-next-level-k8s-networking-with-cilium.pdf).

### Demo: Cilium Identity & Hubble

Find all details [here](demos/containerdays/identity/README.md).

### Demo: Cluster Mesh

Find all details [here](demos/containerdays/clustermesh/README.md).

### Demo: Service Mesh

Find all details [here](demos/containerdays/servicemesh/README.md).

## Continous Lifecycle / Container Conf 2023

### Slides

The slides are available [here](demos/containerconf/containerconf-next-level-k8s-networking-with-cilium.pdf).

### Demo: Cilium Identity & Hubble

Find all details [here](demos/containerconf/identity/README.md).

### Demo: Cluster Mesh

Find all details [here](demos/containerconf/clustermesh/README.md).

### Demo: Service Mesh

Find all details [here](demos/containerconf/servicemesh/README.md).
