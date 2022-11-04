### Каталог для тестирования логированию

На основе материалов:

- https://docs.fluentd.org/v/0.12/articles/docker-logging-efk-compose

Дополнительно:

- https://stackoverflow.com/questions/57694391/how-to-run-fluentd-in-docker-within-the-internal-network
- https://www.solhall.dev/article/using-service-names-in-docker-log-driver
- https://stackoverflow.com/questions/69673732/how-to-send-json-log-to-elasticsearch-using-fluentd

Команды:

```
# Удалить остановленные контейнеры
docker rm $(docker ps --filter status=exited -q)

# Запуск
docker-compose up --remove-orphans -d

# Остановка
docker-compose down
```