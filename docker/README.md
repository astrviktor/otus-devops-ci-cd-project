### Каталог для тестирования сборки сервисов в Docker

Команды:

```
# Удалить остановленные контейнеры
docker rm $(docker ps --filter status=exited -q)

# Запуск
docker-compose up --remove-orphans -d

# Остановка
docker-compose down
```

Можно запускать командами вида:

```
docker-compose --env-file .env --file docker-compose.yml \
  --file logging.yml \
  --file monitoring.yml up --remove-orphans -d
```
