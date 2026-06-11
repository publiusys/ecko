#!/usr/bin/env bash

# --- CONFIGURATION (Hardcoded for simplicity) ---
TOTAL_RUNS=10                              # How many times to rerun the whole experiment
TARGET_URL="http://$(kubectl get svc app -n flaw1-fix1 -o jsonpath='{.spec.clusterIP}')"

# Helper function to run Vegeta load
run_rate() {
  local rate=$1
  local duration=$2
  local log_file=$3
  echo "GET ${TARGET_URL}/?burn=20" | \
      vegeta attack -rate="${rate}/s" -duration="${duration}" | \
      vegeta report -every=1s -output="${log_file}"
}

# --- MAIN LOOP FOR RERUNS ---
for run_id in $(seq 5 ${TOTAL_RUNS}); do
  echo "=========================================="
  echo " STARTING EXPERIMENT RUN: ${run_id} @ ${TARGET_URL}"
  echo "=========================================="
  
  # 1. Create a clean folder for this specific run's results
  FOLDER_NAME="experiment_run_${run_id}"
  mkdir -p "${FOLDER_NAME}"

  # 2. Start HPA monitoring in the background and log to watch.log
  echo "NAME   REFERENCE        TARGETS        MINPODS   MAXPODS   REPLICAS   AGE" > "${FOLDER_NAME}/watch.log"
  
  # This loop runs silently in the background ($! grabs its process ID)
  while true; do
      kubectl get hpa -n flaw1-fix1 | tail -n 1 >> "${FOLDER_NAME}/watch.log" 2>/dev/null
      sleep 1
  done &
  WATCHER_PID=$!

  # 3. Execute the Traffic Ramp
  echo "--- Baseline: 10 req/s (1 minute) ---"
  run_rate 10 "1m" "${FOLDER_NAME}/vegeta.1.log"

  echo "--- Spike: 60 req/s (3 minutes) ---"
  run_rate 60 "3m" "${FOLDER_NAME}/vegeta.2.log"

  echo "--- Cool down: 10 req/s (1 minute) ---"
  run_rate 10 "1m" "${FOLDER_NAME}/vegeta.3.log"

  # 4. Ramp finished. Hold and watch for an extra 10 minutes
  echo "--- Traffic ramp finished. Monitoring HPA for an extra 10 minutes... ---"
  sleep 10m

  # 5. Stop the background HPA watcher
  kill ${WATCHER_PID}
  
  echo "RUN ${run_id} COMPLETE! Output saved to folder: ${FOLDER_NAME}"
  echo "------------------------------------------"
done

echo "ALL RUNS COMPLETED SUCCESSFULLY."
