#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y ipmitool
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl

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
