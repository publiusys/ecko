#!/bin/bash
# Usage: ./is-master.sh
# 
# Description:
#	Checks if the node this script is executed on should be initialized as the master node.
#	Prints "MASTER" if the node's IP is 10.1.1.1, and returns exit code 0.
#	Returns exit code 1 otherwise.

if [[ "$(hostname -s)" == "client" ]]; then
	echo "MASTER"
	exit 0
else
	exit 1
fi
