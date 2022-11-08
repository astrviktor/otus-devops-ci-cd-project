# otus-devops-ci-cd-project
Creating continuous delivery process for applications using CI/CD practices and rapid feedback

Техническое задание:

https://github.com/astrviktor/otus-devops-ci-cd-project/blob/gitlab/docs/specification.md

https://github.com/astrviktor/otus-devops-ci-cd-project/blob/gitlab/docs/project.pdf

Общий план:
1. Обеспечить работоспособность сервисов в Docker
2. Дополнить сервисы в Docker логированием и мониторингом и алертингом
3. Поднять Gitlab и Gitlab-runner в Yandex Cloud
4. Поднять VM для Kubernetes, VM для MongoDB, VM для RabbitMQ в Yandex Cloud
5. Настроить манифесты сервисов для Kubernetes для проверки локально через Minikube
6. Настроить пайплайны в Gitlab для тестов и сборки сервисов
7. Настроить чарты сервисов для Kubernetes для проверки локально через Minikube
8. Настроить пайплайны в Gitlab развертывани инфраструктуры и деплоя в Kubernetes
9. Сделать презентацию


### Реализация:
1. Обеспечить работоспособность сервисов в Docker

CHANGELOG: https://github.com/astrviktor/otus-devops-ci-cd-project/blob/master/docker/README.md

```
# Запуск базовых сервисов
make compose-services-up

# Проверка
http://127.0.0.1/?query=blog

# Остановка базовых сервисов
make compose-services-down
```

2. Дополнить сервисы в Docker логированием и мониторингом (и алертингом)

- с логированием

```
# Запуск базовых сервисов с логированием
make compose-services-logging-up

# Проверка Kibana
http://127.0.0.1:5601

# Остановка базовых сервисов с логированием
make compose-services-logging-down
```

- с мониторингом

```
# Запуск базовых сервисов с мониторингом
make compose-services-monitoring-up

# Проверка Prometheus
http://127.0.0.1:9090

# Проверка Grafana
http://127.0.0.1:3000

# Остановка базовых сервисов с мониторингом
make compose-services-monitoring-down
```

- с мониторингом и логированием

```
# Запуск базовых сервисов с мониторингом и логированием
make compose-services-all-up

# Проверка Kibana
http://127.0.0.1:5601

# Проверка Prometheus
http://127.0.0.1:9090

# Проверка Grafana
http://127.0.0.1:3000

# Остановка базовых сервисов с мониторингом и логированием
make compose-services-all-down
```

Пересборка сервисов

```
docker login

export USER_NAME=astrviktor
export SEARCH_ENGINE_VERSION=0.1.0

cd ./docker/search_engine_crawler && bash docker_build.sh && \
  docker push $USER_NAME/search_engine_crawler:$SEARCH_ENGINE_VERSION
  
cd ../search_engine_ui && bash docker_build.sh && \
  docker push $USER_NAME/search_engine_ui:$SEARCH_ENGINE_VERSION
```


3. Поднять Gitlab и Gitlab-runner в Yandex Cloud

CHANGELOG: https://github.com/astrviktor/otus-devops-ci-cd-project/blob/master/gitlab/README.md


- Работа с gitlab локально

```
# Запуск gitlab локально в Docker
make gitlab-local-up

# Нужно подождать 5-10 минут, проверка gitlab
http://127.0.0.1:8080

# Остановка gitlab локально в Docker
make gitlab-local-down
```

- Работа с gitlab в Yandex Cloud

```
# Запуск gitlab в Yandex Cloud
make yc-gitlab-vm-create

# Нужно подождать 5-10 минут, проверка gitlab
http://<EXTERNAL IP>:8080

# Остановка gitlab в Yandex Cloud
make yc-gitlab-vm-delete
```

4. Поднять VM для Kubernetes, VM для MongoDB, VM для RabbitMQ в Yandex Cloud

CHANGELOG: https://github.com/astrviktor/otus-devops-ci-cd-project/blob/master/infra/README.md

Создание базовых образов с помощью Packer

```
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
  
cd ./infra/packer/kubernetes
  
docker run \
  -v `pwd`:/workspace -w /workspace \
  hashicorp/packer:1.8.4 \
  build -var-file=variables.json kubernetes.json
```

Развертывание инстансов с помощью Terraform

Terraform пока не работает с ошибкой

```
Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider
│ yandex-cloud/yandex: could not connect to registry.terraform.io: Failed to
│ request discovery document: 403 Forbidden
╵
```

Но из готовых образов можно развернуть с помощью "yc compute instance create"

```
yc compute instance create \
--name kubernetes \
--cores=4 \
--core-fraction=5 \
--memory=8 \
--preemptible \
--create-boot-disk image-id=fd8i1u9r167bgpfakfdq,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu"

ssh -i ~/.ssh/ubuntu ubuntu@<EXTERNAL IP>
```

5. Настроить манифесты сервисов для Kubernetes для проверки локально через Minikube

CHANGELOG: https://github.com/astrviktor/otus-devops-ci-cd-project/blob/master/kubernetes/README.md

Настроены манифесты и произведена проверка работоспособности сервисов в Kubernetes

Дальше манифесты можно использовать как основу для чартов

6. Настроить пайплайны в Gitlab для тестов и сборки сервисов

CHANGELOG: https://github.com/astrviktor/otus-devops-ci-cd-project/blob/master/kubernetes/README.md

Настроены пайплайны для gitlab для тестов и сборки, а дальнейшем будет добавлен для деплоя

