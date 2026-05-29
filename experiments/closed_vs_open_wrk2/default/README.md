## Hardware
```
Client: c220g5
Servers: c220g1
```

## Config

```
hand32@client1:~/ecko/scripts$ kubectl get nodes
NAME                                                  STATUS   ROLES           AGE   VERSION
client1.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    control-plane   20m   v1.31.14
server2.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    <none>          20m   v1.31.14
server3.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    <none>          20m   v1.31.14
server4.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    <none>          20m   v1.31.14
server5.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    <none>          20m   v1.31.14
server6.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    <none>          20m   v1.31.14
server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   Ready    <none>          20m   v1.31.14
hand32@client1:~/ecko/scripts$ kubectl get pods -o wide
NAME                                            READY   STATUS    RESTARTS      AGE   IP              NODE                                                  NOMINATED NODE   READINESS GATES
hr-client-66dbd95859-z8ggx                      1/1     Running   0             14m   10.10.218.133   client1.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--consul-7d9c6bc889-dv2t4                   1/1     Running   0             18m   10.10.90.130    server4.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--frontend-845556d588-5qr7h                 1/1     Running   0             18m   10.10.204.194   server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--geo-6b965999b7-h245l                      1/1     Running   0             18m   10.10.86.66     server3.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--jaeger-66896c6f75-gjccp                   1/1     Running   0             18m   10.10.49.67     server2.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--memcached-profile-8d5fbdd87-jlt4p         1/1     Running   0             18m   10.10.204.195   server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--memcached-rate-5c7db958f-nmhbt            1/1     Running   0             18m   10.10.218.196   server6.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--memcached-reserve-648b8f46bc-mdnb6        1/1     Running   0             18m   10.10.218.197   server6.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--mongodb-geo-6477878968-r5dfm              1/1     Running   0             18m   10.10.218.198   server6.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--mongodb-profile-8bdd4ffc8-n68lb           1/1     Running   0             18m   10.10.218.195   server6.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--mongodb-rate-64884c64d9-twkxl             1/1     Running   0             18m   10.10.204.196   server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--mongodb-recommendation-6447ffc996-jxb4f   1/1     Running   0             18m   10.10.204.197   server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--mongodb-reservation-66d9bdd88d-ccsjl      1/1     Running   0             18m   10.10.204.198   server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--mongodb-user-75d67db888-nwfgw             1/1     Running   0             18m   10.10.204.199   server7.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--profile-7ccbc85db7-w2zfm                  1/1     Running   0             18m   10.10.86.67     server3.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--rate-7f49cff6d8-ck6gx                     1/1     Running   0             18m   10.10.179.2     server5.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--recommendation-8455f7ff66-zw64x           1/1     Running   1 (17m ago)   18m   10.10.90.131    server4.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--reservation-5788f5c64d-fs4p5              1/1     Running   1 (17m ago)   18m   10.10.90.132    server4.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--search-6b6fc5bfd5-bw9v7                   1/1     Running   0             18m   10.10.90.133    server4.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
root--user-544d79db75-zfn24                     1/1     Running   2 (17m ago)   18m   10.10.86.68     server3.hand32-306962.bayopsys-pg0.wisc.cloudlab.us   <none>           <none>
```