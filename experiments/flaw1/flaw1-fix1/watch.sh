#!/usr/bin/env bash
echo "NAME   REFERENCE        TARGETS        MINPODS   MAXPODS   REPLICAS   AGE"
while true; do
    kubectl get hpa -n flaw1-fix1 | tail -n 1
    sleep 1
done
