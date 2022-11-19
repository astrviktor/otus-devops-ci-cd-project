### Настройка Bastion

Для безопасности нужно убрать внешние IP адреса у VM 
и сделать доступ через Bastion

При необходимости, доступ к VM можно давать включением Load Balancer
иди включением внешнего IP

```
yc compute instance create \
--name bastion \
--cores=2 \
--core-fraction=5 \
--memory=512MB \
--preemptible \
--create-boot-disk image-id=fd83a20ua7cu594osbio,size=20GB \
--network-interface subnet-name=public-subnet,nat-ip-version=ipv4,ipv4-address=192.168.11.11 \
--zone=ru-central1-a \
--metadata serial-port-enable=1 \
--metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu"
```

Как настроить Bastion:

https://cloud.yandex.ru/docs/tutorials/routing/nat-instance

В сервисах используются следующие порты:

- 192.168.10.10:8080  - Gitlab
- 192.168.10.20:30601 - Kibana
- 192.168.10.20:30090 - Prometheus
- 192.168.10.20:30300 - Grafana
- 192.168.10.20:30801 - search-engine-ui stage
- 192.168.10.20:30802 - search-engine-crawler stage
- 192.168.10.20:30811 - search-engine-ui prod
- 192.168.10.20:30812 - search-engine-crawler prod

Для работы с сервисами нужно пробросить порты себе локально, пример:

```
# Примеры

ssh -L 8080:192.168.10.10:8080 -i ~/.ssh/ubuntu ubuntu@51.250.10.12
ssh -L 5601:192.168.10.20:30601 -L 8080:192.168.10.10:8080 -i ~/.ssh/ubuntu -J ubuntu@51.250.84.192 ubuntu@192.168.10.10

ssh -L 8080:192.168.10.10:8080 -L 5601:192.168.10.20:30601 \
-L 9090:192.168.10.20:30090 -L 3000:192.168.10.20:30300 \
-L 8801:192.168.10.20:30801 -L 8811:192.168.10.20:30811 \
-i ~/.ssh/ubuntu ubuntu@51.250.10.12

ssh -i ~/.ssh/ubuntu -J ubuntu@51.250.10.12 ubuntu@192.168.10.20
```




