# Hubble in action

## Prerequisites

```shell
# Port-forward to access the Hubble API
cilium hubble port-forward&
#Open the Hubble UI in your browser
cilium hubble ui
# Install the Star Wars demo application
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/http-sw-app.yaml
```

## Demo

```shell
# Test acces to the Death Star
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec xwing -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port
# Observe the traffic in the Hubble CLI
hubble observe --pod demo/deathstar-54bb8475cc-vhqwq
# Create deny policy to make traffic visible
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/main/examples/minikube/sw_deny_policy.yaml
# Test acces to the Death Star again
kubectl exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
# Allow only Empire to access the Death Star
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/main/examples/minikube/sw_l3_l4_policy.yaml
# Test acces to the Death Star again
kubectl exec xwing -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec xwing -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec tiefighter -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port
# Block access to the exhaust API
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/main/examples/minikube/sw_l3_l4_l7_policy.yaml
kubectl exec tiefighter -- curl -s -XPOST deathstar.demo.svc.cluster.local/v1/request-landing
kubectl exec tiefighter -- curl -s -XPUT deathstar.demo.svc.cluster.local/v1/exhaust-port
```
