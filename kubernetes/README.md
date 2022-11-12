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
kubectl apply -f ./kubernetes/services/namespaces/

# Развертывание mongodb
kubectl apply -n search-engine -f ./kubernetes/services/search-engine/mongodb/

# Развертывание rabbitmq
kubectl apply -n search-engine -f ./kubernetes/services/search-engine/rabbitmq/


# Развертывание search-engine-crawler
kubectl apply -n search-engine -f ./kubernetes/services/search-engine/search-engine-crawler/

# Развертывание search-engine-ui
kubectl apply -n search-engine -f ./kubernetes/services/search-engine/search-engine-ui/

# Проверка
kubectl get pods --selector component=search-engine-ui -n search-engine
kubectl port-forward search-engine-ui-98dd5bd46-vzzzv 8080:8000 -n search-engine

# Логи подов
kubectl get pods -n search-engine
kubectl logs pod-name -n search-engine
```

3.Создание манифестов для логирования

https://medium.com/avmconsulting-blog/how-to-deploy-an-efk-stack-to-kubernetes-ebc1b539d063

```
# Развертывание elasticsearch
kubectl apply -n logging -f ./kubernetes/services/logging/elasticsearch/

# Развертывание kibana
kubectl apply -n logging -f ./kubernetes/services/logging/kibana/

# Развертывание fluentd
kubectl apply -n logging -f ./kubernetes/services/logging/fluentd/

```

4.Создание манифестов для мониторинга

https://devopscube.com/node-exporter-kubernetes/

```
# Развертывание node-exporter
kubectl apply -n monitoring -f ./kubernetes/services/monitoring/node-exporter

# Развертывание prometheus
kubectl apply -n monitoring -f ./kubernetes/services/monitoring/prometheus

# Развертывание grafana
kubectl apply -n monitoring -f ./kubernetes/services/monitoring/grafana

# Развертывание alertmanager
kubectl apply -n monitoring -f ./kubernetes/services/monitoring/alertmanager

# Развертывание alertmanager-bot
kubectl apply -n monitoring -f ./kubernetes/services/monitoring/alertmanager-bot

```

5.Установка helm3

...

6.Создание чартов для сервисов

...

7.Проверка чартов локально

...