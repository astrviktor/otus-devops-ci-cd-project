#!/bin/bash
echo "================= Configure Kubernetes ================="

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sudo kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo "================= Done ================="
