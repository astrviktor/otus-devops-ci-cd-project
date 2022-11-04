# otus-devops-ci-cd-project
Creating continuous delivery process for applications using CI/CD practices and rapid feedback

Техническое задание:

...

Общий план:
1. Обеспечить работоспособность сервисов в Docker
2. Дополнить сервисы в Docker логированием и мониторингом и алертингом
3. Поднять Gitlab и Gitlab-runner в Yandex Cloud
4. Поднять Kubernetes в Yandex Cloud
5. Настроить манифесты сервисов для Kubernetes
6. Настроить пайплайн в Gitlab для деплоя в Kubernetes


### Реализация:
1. Обеспечить работоспособность сервисов в Docker

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