#!/bin/bash
# Usage: ./init-as-master.sh
#
# Description:
# 	If this script is run on the master node, then it will initialize the kubernetes cluster as well as installing the Calico network add-on plugin.

if ./is-master.sh; then
	sudo kubeadm init --pod-network-cidr=10.10.0.0/16

	mkdir -p $HOME/.kube
  	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  	sudo chown $(id -u):$(id -g) $HOME/.kube/config

	kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
	curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml -O
	sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.10.0.0\/16/g' custom-resources.yaml
	kubectl create -f custom-resources.yaml
fi
