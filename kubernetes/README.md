### Настроить манифесты сервисов для Kubernetes для проверки локально через Minikube

1.Установка minikube

- https://www.linuxtechi.com/how-to-install-minikube-on-ubuntu/

В minikube Ingress идет в виде плагина

```
# Включение Ingress
minikube addons enable ingress

# Настройка
minikube config set cpus 4
minikube config set memory 8192

# Старт
minikube start

# Удаление
minikube delete
```

В обычный Kubernetes Ingress нужно будет установить отдельно


2.Создание манифестов для сервисов и проверка локально

```
# Создание namespace
kubectl apply -f ./kubernetes/services/namespaces/production-namespace.yml

# Развертывание mongodb
kubectl apply -n production -f ./kubernetes/services/mongodb/mongodb-deployment.yml
kubectl apply -n production -f ./kubernetes/services/mongodb/mongodb-service.yml

# Развертывание rabbitmq
kubectl apply -n production -f ./kubernetes/services/rabbitmq/rabbitmq-deployment.yml
kubectl apply -n production -f ./kubernetes/services/rabbitmq/rabbitmq-service.yml


# Развертывание search-engine-crawler
kubectl apply -n production -f ./kubernetes/services/search-engine-crawler/search-engine-crawler-deployment.yml
kubectl apply -n production -f ./kubernetes/services/search-engine-crawler/search-engine-crawler-service.yml


# Развертывание search-engine-ui
kubectl apply -n production -f ./kubernetes/services/search-engine-ui/search-engine-ui-deployment.yml
kubectl apply -n production -f ./kubernetes/services/search-engine-ui/search-engine-ui-service.yml

# Проверка
kubectl get pods --selector component=search-engine-ui -n production
kubectl port-forward search-engine-ui-98dd5bd46-vzzzv 8080:8000 -n production

# Логи подов
kubectl get pods -n production
kubectl logs pod-name -n production
```

3.Установка helm3

...

4.Создание чартов для сервисов

...

5.Проверка локально

...