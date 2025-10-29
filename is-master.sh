#!/bin/bash
# Usage: ./is-master.sh
# 
# Description:
#	Checks if the node this script is executed on should be initialized as the master node.
#	Prints "MASTER" if the node's IP is 10.1.1.1, and returns exit code 0.
#	Returns exit code 1 otherwise.
#
# Author: Seth Moore (slmoore@hamilton.edu)
#
# Last Modified: 10/28/2025

if [[ "$(hostname -I)" == *"10.10.1.1"* ]]; then
	echo "MASTER"
	exit 0
else
	exit 1
fi
