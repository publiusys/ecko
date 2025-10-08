#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y ipmitool
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl

sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter
