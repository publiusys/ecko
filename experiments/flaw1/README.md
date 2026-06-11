## Flaw 1 — HPA Is Always Late
```
The core problem: HPA can only react to problems after they've already happened.
Here's the sequence when traffic suddenly doubles:

Traffic spikes → your pods start working harder
HPA has to wait for metrics-server to notice the CPU went up (up to 60 seconds)
HPA decides "okay, I need more pods" and creates them
The new pods take time to start up and pass health checks (30 seconds to 2+ minutes)
Only then does your app stop struggling

What the experiment shows: You'll see k6's P99 latency spike sharply right after the traffic ramp starts, then gradually recover as the new pods come online. The spike is the lag.
```

### misc
```
export TARGET_URL=http://$(kubectl get svc app -n flaw1 -o jsonpath='{.spec.clusterIP}')
export TARGET_URL=http://$(kubectl get svc app -n flaw1 -o jsonpath='{.spec.clusterIP}')
export NAMESPACE=flaw1
```