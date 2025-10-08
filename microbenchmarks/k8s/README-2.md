## Deploying simple2.yaml

```
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl apply -f simple2.yaml
deployment.apps/simple2 created

hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP            NODE                                                NOMINATED NODE   READINESS GATES
simple2-c89d65bfc-phtgg   2/2     Running   0          3s    10.10.118.7   node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>

hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl describe pod simple2-c89d65bfc-phtgg
Name:             simple2-c89d65bfc-phtgg
Namespace:        default
Priority:         0
Service Account:  default
Node:             node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us/128.105.146.3
Start Time:       Wed, 08 Oct 2025 13:01:33 -0500
Labels:           app=simple2
                  pod-template-hash=c89d65bfc
Annotations:      cni.projectcalico.org/containerID: 2f006aa6bc02be19cde9c565a0556cb776bcc6dfcce1dc508332bb9b09b35c10
                  cni.projectcalico.org/podIP: 10.10.118.7/32
                  cni.projectcalico.org/podIPs: 10.10.118.7/32
Status:           Running
IP:               10.10.118.7
IPs:
  IP:           10.10.118.7
Controlled By:  ReplicaSet/simple2-c89d65bfc
Containers:
  client:
    Container ID:  containerd://24ee5b80cfae78a2466b571dd039148f7823ab7b867da00312cbc12afa496bc6
    Image:         ubuntu:latest
    Image ID:      docker.io/library/ubuntu@sha256:728785b59223d755e3e5c5af178fab1be7031f3522c5ccd7a0b32b80d8248123
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/bash
      -c
      apt update -y; touch /log-share/hello.txt; echo "🟢🟢 Done. Sleeping for 30 days 🟢🟢"; sleep 30d;

    State:          Running
      Started:      Wed, 08 Oct 2025 13:01:34 -0500
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /log-share/ from log-share (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-d6lp9 (ro)
  server:
    Container ID:  containerd://ceb6960d0e804578afeb63a368f421c3d738c79c683b3b86e63a37ed75dd5eb6
    Image:         ubuntu:latest
    Image ID:      docker.io/library/ubuntu@sha256:728785b59223d755e3e5c5af178fab1be7031f3522c5ccd7a0b32b80d8248123
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/bash
      -c
      apt update -y; echo "🟢🟢 Done. Sleeping for 30 days 🟢🟢"; sleep 30d;

    State:          Running
      Started:      Wed, 08 Oct 2025 13:01:35 -0500
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /log-share/ from log-share (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-d6lp9 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  log-share:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
  kube-api-access-d6lp9:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  14s   default-scheduler  Successfully assigned default/simple2-c89d65bfc-phtgg to node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us
  Normal  Pulling    13s   kubelet            Pulling image "ubuntu:latest"
  Normal  Pulled     13s   kubelet            Successfully pulled image "ubuntu:latest" in 543ms (543ms including waiting). Image size: 29732420 bytes.
  Normal  Created    13s   kubelet            Created container: client
  Normal  Started    13s   kubelet            Started container client
  Normal  Pulling    13s   kubelet            Pulling image "ubuntu:latest"
  Normal  Pulled     12s   kubelet            Successfully pulled image "ubuntu:latest" in 468ms (468ms including waiting). Image size: 29732420 bytes.
  Normal  Created    12s   kubelet            Created container: server
  Normal  Started    12s   kubelet            Started container server

hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl logs simple2-c89d65bfc-phtgg -c client

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://archive.ubuntu.com/ubuntu noble InRelease [256 kB]
Get:2 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:3 http://archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:4 http://archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Get:5 http://archive.ubuntu.com/ubuntu noble/universe amd64 Packages [19.3 MB]
Get:6 http://archive.ubuntu.com/ubuntu noble/restricted amd64 Packages [117 kB]
Get:7 http://archive.ubuntu.com/ubuntu noble/multiverse amd64 Packages [331 kB]
Get:8 http://archive.ubuntu.com/ubuntu noble/main amd64 Packages [1808 kB]
Get:9 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Packages [1138 kB]
Get:10 http://archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [1925 kB]
Get:11 http://archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Packages [38.9 kB]
Get:12 http://archive.ubuntu.com/ubuntu noble-updates/restricted amd64 Packages [2625 kB]
Get:13 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1887 kB]
Get:14 http://archive.ubuntu.com/ubuntu noble-backports/main amd64 Packages [49.4 kB]
Get:15 http://archive.ubuntu.com/ubuntu noble-backports/universe amd64 Packages [33.9 kB]
Get:16 http://security.ubuntu.com/ubuntu noble-security/restricted amd64 Packages [2498 kB]
Get:17 http://security.ubuntu.com/ubuntu noble-security/multiverse amd64 Packages [34.6 kB]
Get:18 http://security.ubuntu.com/ubuntu noble-security/main amd64 Packages [1527 kB]
Fetched 34.0 MB in 3s (12.9 MB/s)
Reading package lists...
Building dependency tree...
Reading state information...
1 package can be upgraded. Run 'apt list --upgradable' to see it.
🟢🟢 Done. Sleeping for 30 days 🟢🟢
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl logs simple2-c89d65bfc-phtgg -c server

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://archive.ubuntu.com/ubuntu noble InRelease [256 kB]
Get:2 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:3 http://archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:4 http://archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Get:5 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Packages [1138 kB]
Get:6 http://archive.ubuntu.com/ubuntu noble/multiverse amd64 Packages [331 kB]
Get:7 http://security.ubuntu.com/ubuntu noble-security/multiverse amd64 Packages [34.6 kB]
Get:8 http://security.ubuntu.com/ubuntu noble-security/main amd64 Packages [1527 kB]
Get:9 http://archive.ubuntu.com/ubuntu noble/restricted amd64 Packages [117 kB]
Get:10 http://archive.ubuntu.com/ubuntu noble/universe amd64 Packages [19.3 MB]
Get:11 http://security.ubuntu.com/ubuntu noble-security/restricted amd64 Packages [2498 kB]
Get:12 http://archive.ubuntu.com/ubuntu noble/main amd64 Packages [1808 kB]
Get:13 http://archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [1925 kB]
Get:14 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1887 kB]
Get:15 http://archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Packages [38.9 kB]
Get:16 http://archive.ubuntu.com/ubuntu noble-updates/restricted amd64 Packages [2625 kB]
Get:17 http://archive.ubuntu.com/ubuntu noble-backports/universe amd64 Packages [33.9 kB]
Get:18 http://archive.ubuntu.com/ubuntu noble-backports/main amd64 Packages [49.4 kB]
Fetched 34.0 MB in 2s (15.4 MB/s)
Reading package lists...
Building dependency tree...
Reading state information...
1 package can be upgraded. Run 'apt list --upgradable' to see it.
🟢🟢 Done. Sleeping for 30 days 🟢🟢
```

## Demonstrating sharing folder between the client and server pod
```
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl exec --stdin --tty simple2-c89d65bfc-phtgg -c client -- /bin/bash
root@simple2-c89d65bfc-phtgg:/# ls /log-share/
hello.txt
root@simple2-c89d65bfc-phtgg:/# exit
exit
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl exec --stdin --tty simple2-c89d65bfc-phtgg -c server -- /bin/bash
root@simple2-c89d65bfc-phtgg:/# ls log-share/
hello.txt
root@simple2-c89d65bfc-phtgg:/# exit
exit
```