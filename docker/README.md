### Каталог для тестирования сборки сервисов в Docker

### --- Выполнять все команды из папки docker ---

1.Нужно обеспечить работоспособность сервисов в Docker

Создание Dockerfile для сервисов, настройка, чтобы приложения вытягивались
через git clone при сборке образов

Добавление mongodb и rabbitmq

Создание docker-compose.yml

Команды:

```
# Удалить остановленные контейнеры
docker rm $(docker ps --filter status=exited -q)

# Запуск
docker-compose up --remove-orphans -d

# Остановка
docker-compose down
```

2.Дополнить сервисы в Docker логированием и мониторингом и алертингом

- logging.yml добавляет логирование
- monitoring.yml добавляет мониторинг и алертинг

Можно запускать командами вида:

```
docker-compose --env-file .env --file docker-compose.yml \
  --file logging.yml \
  --file monitoring.yml up --remove-orphans -d
```
