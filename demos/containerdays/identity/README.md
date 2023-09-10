# Cilium Identity & Hubble

## Prerequisites

```shell
# Port-forward to access the Hubble API
cilium --context aks-cilium-demo-01 hubble port-forward&

# Create namespace demo
kubectl --context aks-cilium-demo-01 create ns demo

# Install the Star-Wars demo application into the demo namespace
kubectl --context aks-cilium-demo-01 -n demo create -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/http-sw-app.yaml
```

## Demo

```shell

# Test access to the Death Star
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl --context aks-cilium-demo-01 -n demo exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing

# Observe the traffic in the Hubble CLI
hubble observe --namespace demo --port 80

# View Identity with K8s CRDs
kubectl --context aks-cilium-demo-01 get ciliumidentities.cilium.io --show-labels
kubectl --context aks-cilium-demo-01 get ciliumidentities.cilium.io <IDENTITY_ID> -o yaml

# View Identity with Cilium CLI on Cilium Agents
kubectl --context aks-cilium-demo-01 -n kube-system exec -c cilium-agent cilium- -- cilium identity list
kubectl --context aks-cilium-demo-01 -n kube-system exec -c cilium-agent cilium- -- cilium identity get <IDENTITY_ID>

# Open the Hubble UI in your browser
cilium --context aks-cilium-demo-01 hubble ui

# Create deny all policy
kubectl --context aks-cilium-demo-01 -n demo apply -f deny-all.yaml

# Test access to the Death Star again
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl --context aks-cilium-demo-01 -n demo exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing

# Inspect network policy
kubectl --context aks-cilium-demo-01 -n demo get ciliumnetworkpolicies.cilium.io empire-default-deny -o yaml

# Allow only Empire labeled pods to access the Death Star
kubectl --context aks-cilium-demo-01 -n demo apply -f l3-l4.yaml

# Test access to the Death Star again
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl --context aks-cilium-demo-01 -n demo exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing

# View the CiliumNetworkPolicy
kubectl --context aks-cilium-demo-01 -n demo get cnp rule1 -o yaml

kubectl --context aks-cilium-demo-01 -n kube-system exec -it -c cilium-agent cilium- -- cilium policy get

kubectl --context aks-cilium-demo-01 -n kube-system exec -it -c cilium-agent cilium- -- cilium policy selectors
```

## Bonus: Layer 7 Protocol Visibility

```shell
# Enable Layer 7 Protocol Visibility
# <{Traffic Direction}/{L4 Port}/{L4 Protocol}/{L7 Protocol}>
kubectl --context aks-cilium-demo-01 -n demo annotate pod tiefighter policy.cilium.io/proxy-visibility="<Egress/80/TCP/HTTP>"

# Test Death Star vulnerability
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port

# Allow only Get on /v1/request-landing
kubectl --context aks-cilium-demo-01 -n demo apply -f l7.yaml

# Test Death Star vulnerability
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl --context aks-cilium-demo-01 -n demo exec tiefighter -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port
```
