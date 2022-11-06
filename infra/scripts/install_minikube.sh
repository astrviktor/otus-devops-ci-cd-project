#!/bin/bash
echo "================= Updating & Upgrading System ================="
sudo apt-get update -y
#&& sudo apt-get upgrade -y
#sudo apt-get install htop -y

echo "================= Installing components ================="
#sudo apt install curl apt-transport-https git iptables-persistent -y
sudo apt install curl git htop -y

echo "================= Installing Docker ================="
sudo apt -y install docker docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "================= Adding user ubunti to group docker ================="
sudo gpasswd -a ubuntu docker
sudo su - ubuntu
#sudo usermod -aG docker ubuntu
#sudo newgrp docker


echo "================= Installing Minikube ================="
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo cp minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube

minikube version

echo "================= Installing Kubectl ================="
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version -o yaml

echo "================= Starting Minikube ================="
#minikube start --driver=docker
#minikube start --addons=ingress --cpus=4 --cni=flannel --install-addons=true --kubernetes-version=stable --memory=6g
#minikube start --cpus=4 --kubernetes-version=stable --memory=6g
#minikube addons enable ingress

echo "================= Done ================="