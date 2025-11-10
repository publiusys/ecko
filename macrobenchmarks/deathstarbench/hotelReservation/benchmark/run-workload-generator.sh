#!/bin/bash
# Usage: ./run-workload-generator.sh

export HOST_NAME=$(hostname)
echo $HOST_NAME
envsubst < test.yaml | kubectl apply -f -
