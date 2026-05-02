# __Hotel Reservation Benchmark: Workload Generators__

This folder contains YAML files for deploying workload generator pods to the kubernetes cluster

## __outdated-hr-client.yaml__

This is the original YAML file for deploying the workload generator. It is no longer used because:
1. The nodeName field is hardcoded
2. Uses a CentOS image

## __hr-client.yaml__

This is the current YAML file used for deploying the workload generator. It cannot be deployed with `kubectl apply -f hr-client.yaml` because the nodeName field is `${HOST_NAME}`. In order to deploy this pod, use `scripts/run-workload-generator.sh`

## __modified-hr-client.yaml__

Currently unused