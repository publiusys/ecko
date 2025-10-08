## STRESS-NG YAML
```
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl apply -f stressng.yaml
deployment.apps/stressng created

hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE    IP             NODE                                                NOMINATED NODE   READINESS GATES
simple2-c89d65bfc-phtgg    2/2     Running   0          121m   10.10.118.7    node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
stressng-c5646876f-b4v2g   2/2     Running   0          6s     10.10.118.10   node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>

hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl logs -f stressng-c5646876f-b4v2g
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=stressng-c5646876f-b4v2g
CPUS=22
PWD=/
TIME=10
HOME=/root
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
SHLVL=1
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_=/usr/bin/env
stress-ng: info:  [551] setting to a 10 secs run per stressor
stress-ng: info:  [551] dispatching hogs: 22 cpu
stress-ng: info:  [551] skipped: 0
stress-ng: info:  [551] passed: 22: cpu (22)
stress-ng: info:  [551] failed: 0
stress-ng: info:  [551] metrics untrustworthy: 0
stress-ng: info:  [551] successful run completed in 10.01 secs
🟢🟢 Done. Sleeping for 30 days 🟢🟢

```