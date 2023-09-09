# Cilium Identity & Hubble

## Prerequisites

```shell
# Port-forward to access the Hubble API
cilium hubble port-forward&

# Create namespace demo
kubectl create ns demo

# Set demo as default namespace
kubectl config set-context --current --namespace=demo

# Install the Star-Warss demo application into the demo namespace
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/http-sw-app.yaml
```

## Demo

```shell

# Test access to the Death Star
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing

# Observe the traffic in the Hubble CLI
hubble observe --namespace demo --port 80


# View Identity with K8s CRDs
kubectl get ciliumidentities.cilium.io --show-labels
kubectl get ciliumidentities.cilium.io <IDENTITY_ID> -o yaml

# View Identity with Cilium CLI on Cilium Agents
kubectl -n kube-system exec cilium -- cilium identity list
kubectl -n kube-system exec cilium -- cilium identity get <IDENTITY_ID>

# Open the Hubble UI in your browser
cilium hubble ui

# Create deny all policy
kubectl apply -f deny-all.yaml

# Test access to the Death Star again
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing

# Inspect network policy
kubectl get ciliumnetworkpolicies.cilium.io empire-default-deny -o yaml

# Allow only Empire labeled pods to access the Death Star
kubectl apply -f l3-l4.yaml

# Test access to the Death Star again
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing

# View the CiliumNetworkPolicy
kubectl get cnp rule1 -o yaml

kubectl exec -it -n kube-system cilium -- cilium policy selectors
```

## Bonus: Layer 7 Protocol Visibility

```shell
# Enable Layer 7 Protocol Visibility
# <{Traffic Direction}/{L4 Port}/{L4 Protocol}/{L7 Protocol}>
kubectl annotate pod tiefighter policy.cilium.io/proxy-visibility="<Egress/80/TCP/HTTP>"

# Test Death Star vulnerability
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec tiefighter -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port

# Allow only Get on /v1/request-landing
kubectl apply -f l7.yaml

# Test Death Star vulnerability
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec tiefighter -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port
```
