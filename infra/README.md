### Поднять VM для Kubernetes, VM для MongoDB, VM для RabbitMQ в Yandex Cloud (потом перенести в Gitlab)

Нужно подготовить образы и поднять VM

Можно следующим образом:
- RabbitMQ - Packer подготовка образа + Terraform
- RabbitMQ - Packer подготовка образа + Terraform
- Kubernetes - Packer подготовка образа + Terraform
Если останется время, можно попробовать:
- Добавить Ansible
- MongoDB - Yandex Managed Service for MongoDB
- Kubernetes - Yandex Managed Service for Kubernetes


Приложения:
- Будут находиться в Kubernetes, и там же + Мониторинг + Логирование
- RabbitMQ и MongoDB на отдельных VM / Yandex Managed Service
- На первом этапе можно все разместить в Kubernetes 

1.Подготовка скриптов и проверка через создание инстанса со скриптом инициализации
```
# создание инстанса со скриптом инициализации mongodb
yc compute instance create \
--name mongodb \
--cores=2 \
--core-fraction=5 \
--memory=4 \
--preemptible \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu" \
--metadata-from-file user-data=./packer/mongodb/install_mongodb.sh

# просмотр созданных инстансов
yc compute instances list

# удаление инстанса
yc compute instance delete --name mongodb
```


2.Настройка Packer и создание базового образа MongoDB

Для Packer нужен Service Account

```
yc iam service-account list

+----------------------+--------+
|          ID          |  NAME  |
+----------------------+--------+
| aje1234567890ds48dbq | packer |
+----------------------+--------+

Параметры Yandex Cloud
yc config list

# Нужно создать IAM key и экспортировать его в файл

yc iam key create --service-account-id aje1234567890ds48dbq --output ./packer/key.json

нужны файлы mongodb.json variables.json

Запуск Packer через Docker
cd ./infra/packer/mongodb
  
docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/packer:1.8.4 \
  build -var-file=variables.json mongodb.json
  
cd ./infra/packer/rabbitmq
  
docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/packer:1.8.4 \
  build -var-file=variables.json rabbitmq.json  
```

3.Настройка Terraform

```
cd ./infra/terraform/mongodb/

docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/terraform:1.3.4 \
  --version

docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/terraform:1.3.4 \
  providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=linux_amd64 -platform=darwin_arm64 yandex-cloud/yandex

docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/terraform:1.3.4 \
  init
  
По tеterraform появляется ошибка:

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider
│ yandex-cloud/yandex: could not connect to registry.terraform.io: Failed to
│ request discovery document: 403 Forbidden
╵

Скорее всего, нужно через VPN но в данный момент нет настроенного, можно отложить

И создать VM через "yc compute instance create" с нужным image-id
```

4.Создание инстансов из Packer образа

```
yc compute image list

# MongoDB

yc compute instance create \
--name mongodb \
--cores=2 \
--core-fraction=5 \
--memory=4 \
--preemptible \
--create-boot-disk image-id=fd8k52u1ps7s3af7657a,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu"

# RabbitMQ

yc compute instance create \
--name rabbitmq \
--cores=2 \
--core-fraction=5 \
--memory=4 \
--preemptible \
--create-boot-disk image-id=fd89c4c6dlgstr2k9lq2,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu"

ssh -i ~/.ssh/ubuntu ubuntu@ExternalIP
```


5.Для дальнейшей работы нужна VM с Kubernetes

Minikube

- https://www.linuxtechi.com/how-to-install-minikube-on-ubuntu/
- https://minikube.sigs.k8s.io/docs/handbook/accessing/

Kubernetes master node

- https://www.dmosk.ru/instruktions.php?object=kubernetes-ubuntu
- https://eax.me/kubernetes-single-node-cluster/

```
cd ./infra/packer/kubernetes
  
docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/packer:1.8.4 \
  build -var-file=variables.json kubernetes.json
  
yc compute instance create \
--name kubernetes \
--cores=2 \
--core-fraction=5 \
--memory=4 \
--preemptible \
--create-boot-disk image-id=fd8i1u9r167bgpfakfdq,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu"

ssh -i ~/.ssh/ubuntu ubuntu@51.250.15.171 
```
