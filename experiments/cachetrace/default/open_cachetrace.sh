#!/bin/bash

#set -x

export NITERS=${NITERS:="2"}
export MAXRPS=${MAXRPS:="800"}
export DURATION=${DURATION:="300s"}
export SCRIPT=${SCRIPT:="/wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua"}
export TRACE=${TRACE:="/cluster10.rps.txt"}

echo "[INFO] TRACE ${TRACE}"
echo "[INFO] MAXRPS ${MAXRPS}"
echo "[INFO] NITERS ${NITERS}"
echo "[INFO] DURATION ${DURATION}"
    
function sweep1()
{
    RESULTS_DIR="results/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$RESULTS_DIR"
    
    for (( i=0; i<${NITERS}; i++ )); do
	echo "[RUN] /wrk2-open/wrk --threads=32 --connections=32 --trace=${TRACE} --maxrps={MAXRPS} --duration=${DURATION} --script=${SCRIPT} http://frontend.default.svc.cluster.local:5000"
	OUT="${RESULTS_DIR}/open_cachetrace_sweep1_${RPS}rps_${i}iter.log"
	/wrk2-open/wrk --threads=32 --connections=32 --trace=${TRACE} --maxrps=${MAXRPS} --duration=${DURATION} --script=${SCRIPT} http://frontend.default.svc.cluster.local:5000 2>&1 | tee "$OUT"
	sleep 10
    done
}

$@
