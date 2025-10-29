#!/bin/bash
# Usage: ./join-as-worker.sh
#
# Description: 
# If the node this script is run on is not the master node, then it will attempt to join the kubernetes cluster.
#
# Author: Seth Moore (slmoore@hamilton.edu)
#
# Last Modified: 10/28/2025

if ! ./is-master.sh; then
	until ssh -o StrictHostKeyChecking=no node0 "kubectl get nodes >/dev/null 2>&1"; do
		sleep 5
	done

	JOIN_CMD=$(ssh -o StrictHostKeyChecking=no node0 "sudo kubeadm token create --print-join-command 2>/dev/null")
	sudo $JOIN_CMD
fi
