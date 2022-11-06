#!/bin/bash
echo "================= Updating & Upgrading System ================="
sudo apt-get update -y
#&& sudo apt-get upgrade -y
#sudo apt-get install htop -y

echo "================= Installing components ================="
#sudo apt install curl apt-transport-https git iptables-persistent -y
sudo apt-get install curl git htop -y

echo "================= Installing Docker ================="
sudo apt-get -y install docker docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "================= Adding user ubuntu to group docker ================="
sudo gpasswd -a ubuntu docker
sudo su - ubuntu
#sudo usermod -aG docker ubuntu
#sudo newgrp docker

#echo "================= Change iptables ================="
#iptables -I INPUT 1 -p tcp --match multiport --dports 6443,2379:2380,10250:10252 -j ACCEPT
#iptables -I INPUT 1 -p tcp --match multiport --dports 10250,30000:32767 -j ACCEPT
#netfilter-persistent save

#wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

echo "================= Installing Kubernetes components ================="
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
#sudo apt install -y kubelet kubeadm kubectl
sudo apt install -y kubeadm=1.25.3-00 kubelet=1.25.3-00 kubectl=1.25.3-00
sudo apt-mark hold kubelet kubeadm kubectl
kubectl version --client --output=yaml

echo "================= Creating Cluster ================="
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 \
#  --apiserver-advertise-address=158.160.39.105 \
#  --kubernetes-version stable-1.25

#kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version stable-1.25
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 \
#  --apiserver-advertise-address=158.160.39.105 \


export KUBECONFIG=/etc/kubernetes/admin.conf
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" | sudo tee /etc/environment

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#sudo kubectl taint nodes --all node-role.kubernetes.io/master-
sudo kubectl taint nodes --all node-role.kubernetes.io/control-plane-
#minikube addons enable ingress
echo "================= Done ================="