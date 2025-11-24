#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y ipmitool cpufrequtils conntrack
sudo apt-get install -y docker.io

sudo cp -f power-consumption-logger/power-consumption-logger.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start power-consumption-logger.service

sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

# Set the policy on all CPUs to performance
MAX_CPU=$(( $(nproc) - 1 ))
for i in $(seq 0 $MAX_CPU); do
    echo "Setting CPU $i to performance mode"
    sudo cpufreq-set --cpu $i --governor performance
done

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

