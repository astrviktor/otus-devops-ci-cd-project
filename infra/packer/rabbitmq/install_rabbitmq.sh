echo "================= Updating & Upgrading System ================="
sudo apt-get update
#&& sudo apt-get upgrade -y
sudo apt-get install htop -y

echo "================= Installing Docker ================="
sudo apt -y install docker docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "================= Installing Docker-Compose ================="
sudo apt-get install docker-compose -y

echo "================= Creating docker-compose.yml ================="
cd /home/ubuntu

cat <<EOF> .env
RABBITMQ_USER=rabbit_user0
RABBITMQ_PASS=rabbit_pass0
EOF

cat <<EOF> docker-compose.yml
version: '3'
services:

  rabbitmq:
    image: rabbitmq:3.11.2-management-alpine
    container_name: rabbitmq
    ports:
        - 5672:5672
        - 15672:15672
    volumes:
      - /home/ubuntu/rabbitmq:/var/lib/rabbitmq
    environment:
      - RABBITMQ_DEFAULT_USER=${RABBITMQ_USER}
      - RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASS}
    networks:
      - rabbitmq_net

networks:
  rabbitmq_net:
    driver: bridge

EOF

echo "================= Docker-Compose start ================="
docker-compose up -d

echo "================= Done ================="

