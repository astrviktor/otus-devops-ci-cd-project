# otus-devops-ci-cd-project
Creating continuous delivery process for applications using CI/CD practices and rapid feedback

Нужно создать процесс непрерывной поставки для
приложения с применением практик CI/CD и быстрой
обратной связью

Есть готовое микросервисное приложение, которое включает:
- метрики
- логи приложения
- unit-тесты

Используется
- база данных (mongodb)
- менеджер очередей сообщений (rabbitmq)

https://github.com/express42/search_engine_crawler
https://github.com/express42/search_engine_ui

Требования

1.Автоматизированные процессы создания и управления платформой
- Ресурсы Ya.cloud
- Инфраструктура для CI/CD
- Инфраструктура для сбора обратной связи

2.Использование практики IaC (Infrastructure as Code) для управления
   конфигурацией и инфраструктурой

3.Настроен процесс CI/CD

4.Все, что имеет отношение к проекту хранится в Git

5.Настроен процесс сбора обратной связи
- Мониторинг (сбор метрик, алертинг, визуализация)
- Логирование (опционально)
- Трейсинг (опционально)
- ChatOps (опционально)

6.Документация
- README по работе с репозиторием
- Описание приложения и его архитектуры
- How to start?
- ScreenCast
- CHANGELOG с описанием выполненной работы


Общий план:
1. Обеспечить работоспособность сервисов в Docker
2. Дополнить сервисы в Docker логированием и мониторингом и алертингом
3. Поднять Gitlab и Gitlab-runner в Yandex Cloud
4. Поднять Kubernetes в Yandex Cloud
5. Настроить манифесты сервисов для Kubernetes
6. Настроить пайплайн в Gitlab для деплоя в Kubernetes


Процесс:

1.Обеспечить работоспособность сервисов в Docker

Создание Dockerfile для сервисов, настройка, чтобы приложения вытягивались 
через git clone при сборке образов

Добавление mongodb и rabbitmq

Создание docker-compose.yml

2.Дополнить сервисы в Docker логированием и мониторингом и алертингом

Настроены в отдельных файлах logging.yml и monitoring.yml 
для того, чтобы можно было запускать совместно с основным docker-compose.yml 
файлом командами вида:

```
docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
  --file ./docker/logging.yml \
  --file ./docker/monitoring.yml up --remove-orphans -d
```

