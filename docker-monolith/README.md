### arybach_microservices
arybach microservices repository
added .pre-commit-config.yaml
pre-commit install

### created: docker images > docker-monolith/docker-1.log
### added description of docker image vs docker container

### create docker-host on yc
yc compute instance create \
--name docker-host \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=15 \
--ssh-key ~/.ssh/yc.pub

### output:
done (36s)
id: fhmsfai3es1kh9g2q6vq
folder_id: b1gjev1g87fgira75vkt
created_at: "2023-08-08T04:13:35Z"
name: docker-host
zone_id: ru-central1-a
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: fhmlhd3tsur1m2df99r5
  auto_delete: true
  disk_id: fhmlhd3tsur1m2df99r5
network_interfaces:
  - index: "0"
    mac_address: d0:0d:1c:7a:a4:37
    subnet_id: e9b2kdhg3sqiuc4os6ci
    primary_v4_address:
      address: 10.128.0.18
      one_to_one_nat:
        address: 158.160.35.199
        ip_version: IPV4
gpu_settings: {}
fqdn: fhmsfai3es1kh9g2q6vq.auto.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

### install docker-machine
curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
chmod +x /tmp/docker-machine &&
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

docker-machine version
''' docker-machine version 0.16.2, build bd45ab13

docker-machine create \
--driver generic \
--generic-ip-address=158.160.35.199 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/yc \
docker-host

### checking
docker-machine ls
NAME          ACTIVE   DRIVER    STATE     URL                         SWARM   DOCKER    ERRORS
docker-host   -        generic   Running   tcp://158.160.35.199:2376           v24.0.5

###  configure your shell to use the Docker daemon on the docker-machine-managed host (otherwise it will run locally)
eval $(docker-machine env docker-host)

docker run --rm -ti tehbilly/htop
''' 2GB of memory available
docker run --rm --pid host -ti tehbilly/htop
''' 9GB of memory available

### building reddit docker image and starting container
docker build -t reddit:latest .
docker run --name reddit -d --network=host reddit:latest

check app at: http://158.160.35.199:9292

### push image to docker hub
docker login
docker tag reddit:latest arybach/otus-reddit:1.0
docker push arybach/otus-reddit:1.0

### run from docker hub
docker stop reddit
docker rm reddit

docker run --name reddit -d -p 9292:9292 arybach/otus-reddit:1.0
5fb22e09ecb23d4b5d28e5ba628a7b8f335024833ea287ac3ec972aa791f375e

[0] % docker ps
CONTAINER ID   IMAGE                     COMMAND       CREATED         STATUS         PORTS                                       NAMES
5fb22e09ecb2   arybach/otus-reddit:1.0   "/start.sh"   8 seconds ago   Up 6 seconds   0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   reddit

### clean-up
docker-machine rm docker-host
yc compute instance delete docker-host

file README.md exists and matches /\n\Z/ - why it is failing tests only buddha knows
