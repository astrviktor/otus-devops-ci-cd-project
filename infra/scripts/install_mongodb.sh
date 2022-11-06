#!/bin/bash

echo "================= Updating & Upgrading System ================="
sudo apt-get update
#&& sudo apt-get upgrade -y
sudo apt-get install htop -y

echo "================= Installing Docker ================="
sudo apt -y install docker docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "================= Starting MongoDB ================="

sudo docker run --detach \
  --volume '/home/ubuntu/mongodb:/data/db' \
  --publish 27017:27017 \
  --name mongodb \
  --restart always \
mongo:3.2

echo "================= Done ================="