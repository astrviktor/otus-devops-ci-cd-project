# simple services

compose-services-up:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml up --remove-orphans -d

compose-services-down:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml down


# simple services + logging

compose-services-logging-up:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
      --file ./docker/logging.yml up --remove-orphans -d

compose-services-logging-down:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
	  --file ./docker/logging.yml down


# simple services + monitoring

compose-services-monitoring-up:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
      --file ./docker/monitoring.yml up --remove-orphans -d

compose-services-monitoring-down:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
	  --file ./docker/monitoring.yml down


# simple services + monitoring + logging

compose-services-all-up:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
      --file ./docker/logging.yml \
      --file ./docker/monitoring.yml up --remove-orphans -d

compose-services-all-down:
	docker-compose --env-file ./docker/.env --file ./docker/docker-compose.yml \
      --file ./docker/logging.yml \
	  --file ./docker/monitoring.yml down
