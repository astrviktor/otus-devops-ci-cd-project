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

# gitlab local up and down

gitlab-local-up:
	docker-compose --env-file ./gitlab/.env --file ./gitlab/docker-compose.yml up --remove-orphans -d

gitlab-local-down:
	docker-compose --env-file ./gitlab/.env --file ./gitlab/docker-compose.yml down

# yc gitlab vm create and delete
yc-gitlab-vm-create:
	yc compute instance create \
    --name gitlab-test \
    --cores=4 \
    --core-fraction=5 \
    --memory=8 \
    --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=20GB \
    --network-interface subnet-name=app-subnet,nat-ip-version=ipv4 \
    --zone=ru-central1-a \
    --metadata serial-port-enable=1 \
    --metadata ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDifQpM8FAnJVkbol8HyRk+TT+6FTa7ueantO7DQwnuEfl07H0dZoJY8eqEWlfxugse+4/o/4VTSvptmmR3sE+tpfw9y8h5Ws0sI1rmm7qQSjLjvbkiKPiiUn16jqlTPiaHv4cRUVwLyi/naCqhNOhQS2/uay45z9rOt9x2YtcNpkJhwxHwkhEml61jhM6W/jpTqB7NqsIZiIvFDbnqz9QoG1+pPPcuBhWLKlAQZJ+vq0GgrcHgXQDdihoOfO3jOZtW4YRqVbSaH8H5YZjpdMrnNiFGJxzoVyQSr3J+0DUYoUS9iX/0h37qKWLn74C4HHwYtGD/EZlCB1CQpWaQWNduRMdvQSqmgoQJIfwOYjrZfdizU6eCErR+XObI5EXhC6iH/PLIBoWeHlYA+yBlfjjbbjEnGMtXhVpCKLX/Reqv19HzVeEGciSl/ioI/DzY8Ggz+Xzckvodph/QBW+1TBLWUfeds6JSUlwUFAoPuqYG7sfOFMZYP7HpVv6Om3X/rnE= ubuntu" \
    --metadata-from-file user-data=./gitlab/configscripts/deploy_gitlab.sh

	yc compute instances list

yc-gitlab-vm-delete:
	yc compute instance delete --name gitlab-test
	yc compute instances list
