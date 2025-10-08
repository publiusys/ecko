```
kubectl apply -f auth_default_user.yaml
kubectl apply -f simple.yaml
```

## Helpful commands
```
kubectl get nodes
kubectl get pods
kubectl get pods --all-namespaces
kubectl get pods -o wide
```

## Example getting logs from pod
```
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE                                                NOMINATED NODE   READINESS GATES
simple-9bc9c96d8-v8fvf   1/1     Running   0          32s   10.10.118.3   node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>

hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl logs simple-9bc9c96d8-v8fvf
🟢🟢 Done. Sleeping for 30 days 🟢🟢
```

## Example getting shell access to deployed pod
```
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE                                                NOMINATED NODE   READINESS GATES
simple-9bc9c96d8-v8fvf   1/1     Running   0          32s   10.10.118.3   node1.hand32-273393.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>

hand32@node0:~/ecko/microbenchmarks/k8s$ ./access_cluster.sh simple-9bc9c96d8-v8fvf
root@simple-9bc9c96d8-v8fvf:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@simple-9bc9c96d8-v8fvf:/# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu 24.04.3 LTS"
root@simple-9bc9c96d8-v8fvf:/# uname -a
Linux simple-9bc9c96d8-v8fvf 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
root@simple-9bc9c96d8-v8fvf:/# exit
exit
```

## Delete pod
```
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl delete -f simple.yaml
deployment.apps "simple" deleted
hand32@node0:~/ecko/microbenchmarks/k8s$ kubectl get pods
NAME                     READY   STATUS        RESTARTS   AGE
simple-9bc9c96d8-v8fvf   1/1     Terminating   0          5m49s
```