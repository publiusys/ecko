#!/usr/bin/env bash
TARGET_URL="http://$(kubectl get svc app -n flaw1 -o jsonpath='{.spec.clusterIP}')"

run_rate() {
  local rate=$1
  local duration=$2
  local iter=$3
  echo "GET ${TARGET_URL}/?burn=20" | \
      vegeta attack -rate="${rate}/s" -duration="${duration}" | \
      vegeta report -every=1s -output=vegeta."${iter}".log
}

echo "--- Baseline: 10 req/s ---"
run_rate 10 1m 1
echo "--- Spike: 60 req/s ---"
run_rate 60 3m 2
echo "--- Cool down: 10 req/s ---"
run_rate 10 1m 3
