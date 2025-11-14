#!/bin/bash
# Usage: ./run-experiments.sh

# Partially reset Kubernetes state

reset()
{
	kubectl delete -f /local/repository/macrobenchmarks/deathstarbench/hotelReservation/benchmark/test.yaml 2> /dev/null
	kubectl delete -Rf /local/repository/controllers/hpa/hpa-hotelres-config/ 2> /dev/null
	kubectl delete -Rf /local/repository/macrobenchmarks/deathstarbench/hotelReservation/yamls/ 2> /dev/null

	kubectl apply -Rf /local/repository/macrobenchmarks/deathstarbench/hotelReservation/yamls/
        kubectl wait pod --all --for=condition=Ready --timeout=300s --all-namespaces
	kubectl apply -Rf /local/repository/controllers/hpa/hpa-hotelres-config/
	kubectl wait pod --all --for=condition=Ready --timeout=300s --all-namespaces
	
	echo "Partially reset Kubernetes state."
}

max_replica_experiments=(7 32)
experiment_duration=1200

for max_replica_count in "${max_replica_experiments[@]}"; do
	echo "Starting experiment with $max_replica_count max replica count."

	reset

	/local/repository/scripts/quick-replica-patch.sh 1 "$max_replica_count"

	#kubectl apply -f /local/repository/macrobenchmarks/deathstarbench/hotelReservation/benchmark/test.yaml
	/local/repository/scripts/run-workload-generator.sh

	sleep "$experiment_duration"

	workload_generator_pod_name=$(kubectl get pods -o name | grep hr-client | sed 's|pod/||')
	log_directory_name="/local/repository/max-replica-$max_replica_count-data-$(date +"%Y-%m-%d_%H-%M-%S")/sharelogs"
	mkdir -p "$log_directory_name"
	kubectl cp "$workload_generator_pod_name:/sharelogs/" "$log_directory_name"

	#kubectl cp "$(kubectl get pods -o name | grep hr-client):/sharelogs/" "/local/repository/max-replica-$max_replica_count-data-$(date +"%Y-%m-%d_%H-%M-%S")/sharelogs"
done

exit 0
