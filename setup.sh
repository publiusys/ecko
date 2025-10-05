#!/bin/bash
# usage: setup node_name

node_name=$1

sudo apt-get update -y
sudo apt-get install -y ipmitool
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl

if [ node_name == "node0" ]; then
  touch master.txt
fi
