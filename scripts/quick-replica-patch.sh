#!/bin/bash
# Usage: ./quick-replica-patch.sh <minReplicas> <maxReplicas>

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <minReplicas> <maxReplicas>"
  exit 1
fi

for hpa in $(kubectl get hpa -n default -o jsonpath='{.items[*].metadata.name}'); do
	echo "Patching $hpa..."
	kubectl patch hpa "$hpa" -n default -p "{\"spec\":{\"minReplicas\":$1,\"maxReplicas\":$2}}"
done

exit 0
