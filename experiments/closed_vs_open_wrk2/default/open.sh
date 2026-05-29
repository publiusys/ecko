#!/bin/bash

#set -x

export NITERS=${NITERS:="2"}
export RATES=${RATES:="200 400"}
export DURATION=${DURATION:="120s"}
export SCRIPT=${SCRIPT:="/wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua"}

echo "[INFO] RATES ${RATES}"
echo "[INFO] NITERS ${NITERS}"
echo "[INFO] DURATION ${DURATION}"
    
function sweep1()
{
    RESULTS_DIR="results/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$RESULTS_DIR"
    
    for RPS in ${RATES}; do
	for (( i=0; i<${NITERS}; i++ )); do
	    echo "[RUN] /wrk2-open/wrk --rate=${RPS} --dist=exp --threads=32 --connections=32 --duration=${DURATION} --script=${SCRIPT} http://frontend.default.svc.cluster.local:5000"
	    OUT="${RESULTS_DIR}/open_sweep1_${RPS}rps_${i}iter.log"
	    /wrk2-open/wrk --rate=${RPS} --dist=exp --threads=32 --connections=32 --duration=${DURATION} --script=${SCRIPT} http://frontend.default.svc.cluster.local:5000 2>&1 | tee "$OUT"
	    sleep 10
	done
    done
}

$@
