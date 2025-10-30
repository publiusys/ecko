#!/bin/bash
# Usage: ./configure-benchmark-yaml.sh
#
# Description:
# 	Injects this node's hostname into the nodeName field of benchmark.yaml
#
# Last Modified: 10/29/2025

sed -i "s/HOSTNAME_PLACEHOLDER/$(hostname)/" test.yaml 
