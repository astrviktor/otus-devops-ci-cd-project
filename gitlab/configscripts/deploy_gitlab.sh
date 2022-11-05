#!/bin/bash
#sleep 60
echo "================= Updating & Upgrading System ================="
sudo apt-get update
#&& sudo apt-get upgrade -y
sudo apt-get install htop -y

echo "================= Installing Docker ================="
sudo apt-get install docker docker.io -y

echo "================= Starting Docker ================="
sudo systemctl enable docker
sudo systemctl start docker

echo "================= Installing Docker-Compose ================="
sudo apt-get install docker-compose -y

echo "================= Creating docker-compose.yml ================="
cd /home/ubuntu
export GITLAB_HOME=$(pwd)/gitlab

cat <<EOF> docker-compose.yml
version: '3.7'
services:

  web:
    image: gitlab/gitlab-ce:15.5.2-ce.0
    restart: always
    hostname: 'localhost'
    container_name: gitlab-ce
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://localhost'
    ports:
      - '8080:80'
      - '8443:443'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    networks:
      - gitlab

  gitlab-runner:
    image: gitlab/gitlab-runner:alpine3.15-v15.5.0
    container_name: gitlab-runner
    restart: always
    depends_on:
      - web
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - '$GITLAB_HOME/gitlab-runner:/etc/gitlab-runner'
    networks:
      - gitlab

networks:
  gitlab:
    name: gitlab-network
EOF

echo "================= Docker-Compose start ================="
docker-compose up -d

echo "================= Done ================="

