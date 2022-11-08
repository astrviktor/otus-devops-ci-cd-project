## Запуск Gitlab и Gitlab-runner в Yandex Cloud

### --- Выполнять все команды из папки gitlab ---

1.Запуск Gitlab локально в Docker

- https://www.czerniga.it/2021/11/14/how-to-install-gitlab-using-docker-compose/
- https://habr.com/ru/company/timeweb/blog/680594/

```
docker-compose up --remove-orphans -d
docker-compose down
```

2.Установка и настройка утилиты yc

Установка
- https://cloud.yandex.ru/docs/cli/operations/install-cli

```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | \
    bash -s -- -a
```

Подключение профиля
- https://cloud.yandex.ru/docs/cli/operations/profile/profile-create

```
yc config list
ERROR: profile 'default' not found

yc init

yc config list
информация

yc config profile list
default ACTIVE
```

3.Сгенерировать ключ

```
ssh-keygen -t rsa -f ~/.ssh/yc-user -C yc-user -P ""
```

4.Создать сеть, подсеть и инстанс

```
# создание сети
yc vpc network create --name app-network
id: enpk86ecgrtpblh3hqcq
folder_id: b1gjj7qi24ahoh0btbq1
created_at: "2022-11-04T14:25:57Z"
name: app-network

# создание подсети
yc vpc subnet create \
--name app-subnet \
--zone ru-central1-a \
--range "192.168.10.0/24" \
--network-id "enpk86ecgrtpblh3hqcq"

# создание инстанса
yc compute instance create \
--name gitlab \
--cores=4 \
--core-fraction=5 \
--memory=8 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--ssh-key ~/.ssh/yc-user.pub

# подключение к инстансу
ssh -i ~/.ssh/yc-user yc-user@<Публичный IPv4>

# удаление инстанса
yc compute instance delete --name gitlab

# создание инстанса со скриптом инициализации gitlab
yc compute instance create \
--name gitlab \
--cores=4 \
--core-fraction=5 \
--memory=8 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=20GB \
--network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu" \
--metadata-from-file user-data=./configscripts/deploy_gitlab.sh

# просмотр созданных инстансов
yc compute instances list
```

5.Донастройка gitlab

- Нужно найти и сменить пароль, убрать возможность регистрации

```
# На VM выполнить команду

sudo docker exec -it gitlab-ce grep 'Password:' /etc/gitlab/initial_root_password
Password: Qf/qehD48+XYhBEOWNG7Hg+i5txYuq++TjlQkOx+8fE=

# Нужно зайти в gitlab и сменить пароль, и отключить возможность регистрации
http://51.250.87.143:8080/users/sign_in

root | Qf/qehD48+XYhBEOWNG7Hg+i5txYuq++TjlQkOx+8fE=

# Поменять пароль
http://51.250.87.143:8080/-/profile/password/edit

# Убрать "Sign-up enabled" и нажать "Save changes" 
http://51.250.87.143:8080/admin/application_settings/general#js-signup-settings

```
 
- Нужно подключить gitlab-runner

```
# Взять токен для gitlab-runner
http://51.250.87.143:8080/admin/runners
Register an instance runner
Registration token

# На VM выполнить команду
sudo docker exec -it gitlab-ce grep 'Password:' /etc/gitlab/initial_root_password

sudo docker exec -it gitlab-runner gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "http://gitlab-ce" \
  --clone-url "http://gitlab-ce" \
  --registration-token "14-aKMrW3pvxsoUydPsK" \
  --description "base runner" \
  --maintenance-note "base runner" \
  --tag-list "docker" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected" \
  --docker-network-mode="gitlab-network"
 
 
Обновить страницу, должен быть runner online
http://51.250.87.143:8080/admin/runners

В текущий момент пока функционала достаточно, в дальнейшем можно будет добавить дополнительные настройки
- https
- domain
- ...
```

6.Имеем работающий инстанс с gitlab

Update 2022-11-08:
При сборке docker образов начали возникать ошибки

```
error during connect: Post "http://docker:2375/v1.24/auth": dial tcp: lookup docker: Try again
```

Нужно добавить настройку:

```
ssh -i ~/.ssh/ubuntu ubuntu@158.160.38.135

sudo nano ./gitlab/gitlab-runner/config.toml

volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]

sudo docker stop gitlab-runner
sudo docker rm gitlab-runner
sudo docker-compose up -d
```

https://serverfault.com/questions/1052496/docker-login-to-aws-ecr-from-gitlab-ci-fails-with-dial-tcp-lookup-docker-on-x