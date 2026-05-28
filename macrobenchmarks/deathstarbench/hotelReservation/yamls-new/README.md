## MongoDB and Memcached
```
Pin instances to the dedicated data-tier nodes (node-5 and node-6) using node affinity:

First, label your dedicated data-tier nodes:
kubectl label node node5.hand32-306932.bayopsys-pg0.apt.emulab.net role=data-tier-db
kubectl label node node6.hand32-306932.bayopsys-pg0.apt.emulab.net role=data-tier-db
```

## To apply yamls
```
kubectl apply -Rf .
```