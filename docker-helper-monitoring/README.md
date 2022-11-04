### Каталог для тестирования по мониторингу и алертингу

На основе материалов:

- https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker

Команды:

```
# Удалить остановленные контейнеры
docker rm $(docker ps --filter status=exited -q)

# Запуск
docker-compose up --remove-orphans -d

# Остановка
docker-compose down
```