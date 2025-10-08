# K8s Horizontal Pod Autoscaler

### Dynamic patching
```
kubectl patch hpa [hpa-name] -n [namespace] -p "{\"spec\":{\"minReplicas\":2,\"maxReplicas\":3}}"
```