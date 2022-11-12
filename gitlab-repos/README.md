### Перенос репозиториев для сервисов в gitlab и настройка пайплайнов для сборки и деплоя

- Создать группу в gitlab astrviktor

- Перенастроить gitlab чтобы по умолчанию была ветка master
https://docs.gitlab.com/ee/user/project/repository/branches/default.html

http://158.160.38.135:8080/groups/astrviktor/-/settings/repository
Default branch - master

- Создать пустые репозитории для search_engine_crawler и search_engine_ui

https://github.com/express42/search_engine_crawler
https://github.com/express42/search_engine_ui

Склонировать пустые репозитории к себе, перенести в них код и запушить в gitlab

```
git clone http://158.160.38.135:8080/astrviktor/search_engine_crawler.git

копируем файлы из исходного репозитория, кроме .git

git add .
git commit -m "Initial commit"
git push -u origin master 
```

В итоге имеем клоны репозиториев в гитлабе, нужно добавить пайпланы теста и сборки
и пуша готового образа в репозиторий

```
Добавляем gitlab-ci.yml

Можно попробовать на основе 
https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Python.gitlab-ci.yml

git add .gitlab-ci.yml
git commit -m "Add CI"
git push 
```

Нужно добавить переменные для Docker Hub на группу в gitlab
https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-a-group

### Создание Load Balancer

После развертывания gitlab VM на ней не нужен внешний IP, т.к. после остановки и 
запуска он каждый раз генерируется новый

Нужно убрать внешний IP, поставить фиксированный внутренний

```
# Установить внутренний адрес

yc compute instance update-network-interface \
--name rabbitmq \
--network-interface-index 0 \
--ipv4-address 192.168.10.20

```

Добавить Load Balancer

- Добавить группу VM из которой будет балансироваться

```
# Получите список виртуальных машин:

yc compute instance list

Выберите ID виртуальной машины, которую следует добавить в целевую группу, 
и получите о ней сведения:

yc compute instance get ID

# Создать целевую группу
yc load-balancer target-group create \
  --name gitlab \
  --region-id ru-central1 \
  --target subnet-id=e9b97sh5f1sdl12sbnkf,address=192.168.10.10
  
# Проверка 
yc load-balancer target-group list
```

- Создание сетевого балансировщика с обработчиком и подключенной целевой группой

```
yc load-balancer network-load-balancer create \
  --name load-balancer \
  --region-id ru-central1 \
  --listener name=gitlab-listener,external-ip-version=ipv4,port=80,target-port=8080 \
  --target-group target-group-id=enp5u0m2ojsv8kfvipmh,healthcheck-name=http,healthcheck-http-port=8080,healthcheck-http-path=/users/sign_in
```

### Создание репозитория infra для развертывания нужных VM

Пока не устранил проблемы с terraform, можно сделать репозиторий для инфраструктуры с помощью CLI

Нужно создать в gitlab репозиторий - infra-cli

```
git clone http://158.160.36.189/astrviktor/infra-cli.git

Добавляем gitlab-ci.yml

git add .
git commit -m "Initial commit"
git push -u origin master

git add .gitlab-ci.yml
git commit -m "Add CI"
git push 
 
```

Нужно добавить переменные для Yandex Cloud на репозиторий infra-cli
https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-a-project

Нужно сделать docker-образ для запуска утилиты `ус` и затем использовать его в пайплайнах

```
cd ./gitlab-repos/yc-cli/
sh docker_build.sh
docker login
docker push astrviktor/yc-cli:latest
```