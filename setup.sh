#!/bin/bash

if [[ "$(hostname -I)" == *"10.10.1.1"* ]]; then
  IS_MASTER=true
else
  IS_MASTER=false
fi

sudo apt-get update -y
sudo apt-get install -y ipmitool
sudo apt-get install -y docker.io

sudo cp -f power-consumption-logger/power-consumption-logger.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start power-consumption-logger.service

sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

sudo tee /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward   = 1
EOF

sudo sysctl --system

sudo systemctl enable docker

sudo mkdir /etc/containerd
sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd.service

sudo apt-get install curl ca-certificates apt-transport-https  -y
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-get install -y kubelet kubeadm kubectl

if [ "$IS_MASTER" = true ]; then
	sudo kubeadm init --pod-network-cidr=10.10.0.0/16

	mkdir -p $HOME/.kube
  	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  	sudo chown $(id -u):$(id -g) $HOME/.kube/config

	kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
	curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml -O
	sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.10.0.0\/16/g' custom-resources.yaml
	kubectl create -f custom-resources.yaml
else
	until ssh -o StrictHostKeyChecking=no node0 "kubectl get nodes >/dev/null 2>&1"; do
		sleep 5
	done

	JOIN_CMD=$(ssh -o StrictHostKeyChecking=no node0 "sudo kubeadm token create --print-join-command 2>/dev/null")
	sudo $JOIN_CMD
fi
