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

3.Пересборка сервисов

```
docker login

export USER_NAME=astrviktor
export SEARCH_ENGINE_VERSION=0.1.0

cd ./docker/search_engine_crawler && bash docker_build.sh && \
  docker push $USER_NAME/search_engine_crawler:$SEARCH_ENGINE_VERSION
  
cd ../search_engine_ui && bash docker_build.sh && \
  docker push $USER_NAME/search_engine_ui:$SEARCH_ENGINE_VERSION
```

