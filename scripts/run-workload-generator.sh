#!/bin/bash
# Usage: ./run-workload-generator.sh

export HOST_NAME=$(hostname)
echo $HOST_NAME
envsubst < /local/repository/macrobenchmarks/deathstarbench/hotelReservation/benchmark/test.yaml | kubectl apply -f -
