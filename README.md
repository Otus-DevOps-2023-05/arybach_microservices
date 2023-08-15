# Micorservices
# homework docker-3
wget https://github.com/express42/reddit/archive/microservices.zip
unzip microservices.zip
rm microservices.zip
mv reddit-microservices src

### create docker-host on yc
yc compute instance create \
--name docker-host \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=15 \
--ssh-key ~/.ssh/yc.pub

### copy and paste ip from output above
docker-machine create \
--driver generic \
--generic-ip-address=158.160.113.134 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/yc \
docker-host

### checking
docker-machine ls

###  configure your shell to use the Docker daemon on the docker-machine-managed host (otherwise it will run locally)
eval $(docker-machine env docker-host)

docker pull mongo:latest

Digest: sha256:7769474cddc634e5a90b078f437dabc8816b8a3900cb1710219d1179b805bb8e
Status: Downloaded newer image for mongo:latest

docker build -t arybach/post:1.0 ./post-py
![Alt text](image.png)

docker build -t arybach/comment:1.0 ./comment
![Alt text](image-1.png)

docker build -t arybach/ui:1.0 ./ui
![Alt text](image-2.png)

docker network create reddit
b8e0fc4d4239b224c20e29bf5854f660704f66273088a7fcc9680def88494d2d

### Run containers
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post arybach/post:1.0
docker run -d --network=reddit --network-alias=comment arybach/comment:1.0
docker run -d --network=reddit -p 9292:9292 arybach/ui:1.0

d6bbf2b909fcba122836d0e34e41412580be34b73e4b21f925ed59db20b62b2b
a3a59430f36af061c3a6730e01c3e2f6d965bc644c800f500f9a47c96f3bc766
a0ffa3c0357248e04aced430bdc99623155f8b42d18500cc939d8012fd25a5cf
d4dfc090577ea82288131561cd50280b10fb4221ad1e51b92fd5b3da4c1ae689

### testing
http://158.160.113.134:9292/
![Alt text](image-3.png)

docker kill $(docker ps -q)

[0] % docker images
REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
arybach/ui        1.0       164343101547   20 minutes ago   944MB
arybach/comment   1.0       d489db6a3ab8   21 minutes ago   941MB
arybach/post      1.0       afb5c3be4be6   22 minutes ago   210MB
mongo             latest    fb5fba25b25a   4 weeks ago      654MB

### rebuilding with updated Dockerfile starts with Ubuntu:16 image pull
 => [1/7] FROM docker.io/library/ubuntu:16.04@sha256:1f1a2d56de1d604801a9671f301190704c25d604a416f59e03c04f5c6ffee0d6

REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
arybach/ui        1.0       e622f81d38f8   42 seconds ago   517MB

REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
arybach/comment   1.0       f3035d4028a7   21 seconds ago   252MB

### post-py Dockerfile is already using python:3.6-alpine

### testing
http://158.160.113.134:9292/

### create docker volume
docker volume create reddit_db

docker kill $(docker ps -q)
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post arybach/post:1.0
docker run -d --network=reddit --network-alias=comment arybach/comment:1.0
docker run -d --network=reddit -p 9292:9292 arybach/ui:1.0

### testing
http://158.160.113.134:9292/
all works except for the ALL POSTS (under all Dockerfile versions)

ALL POSTS are not available. These are the logs:
 GET | response_status=200
I, [2023-08-11T13:09:13.889871 #1]  INFO -- : service=ui | event=post_create | request_id=818ee74e-bb6b-4741-85a5-d3622a177b4a | message='Successfully created a post' | params: {"title":"cool title","link":"http://158.160.113.134:9292/new"}
I, [2023-08-11T13:09:13.890191 #1]  INFO -- : service=ui | event=request | path=/new | request_id=818ee74e-bb6b-4741-85a5-d3622a177b4a | remote_addr=110.139.196.116 | method= POST | response_status=303
E, [2023-08-11T13:09:14.244140 #1] ERROR -- : service=ui | event=show_all_posts | request_id=09255b75-be43-4bbf-873e-19ffd345fd8f | message='Failed to read from Post service. Reason: 767: unexpected token at 'Internal Server Error'' | params: "{}"
I, [2023-08-11T13:09:14.256718 #1]  INFO -- : service=ui | event=request | path=/ | request_id=09255b75-be43-4bbf-873e-19ffd345fd8f | remote_addr=110.139.196.116 | method= GET | response_status=200
E, [2023-08-11T13:09:16.485568 #1] ERROR -- : service=ui | event=show_all_posts | request_id=4bf4e841-e969-4de0-ae35-fbbf7d9495a8 | message='Failed to read from Post service. Reason: 767: unexpected token at 'Internal Server Error'' | params: "{}"
I, [2023-08-11T13:09:16.503808 #1]  INFO -- : service=ui | event=request | path=/ | request_id=4bf4e841-e969-4de0-ae35-fbbf7d9495a8 | remote_addr=110.139.196.116 | method= GET | response_status=200
E, [2023-08-11T13:09:18.394232 #1] ERROR -- : service=ui | event=show_all_posts | request_id=29ed60fc-af3a-4e83-9579-5f465f2d31f3 | message='Failed to read from Post service. Reason: 767: unexpected token at 'Internal Server Error'' | params: "{}"
I, [2023-08-11T13:09:18.406945 #1]  INFO -- : service=ui | event=request | path=/ | request_id=29ed60fc-af3a-4e83-9579-5f465f2d31f3 | remote_addr=110.139.196.116 | method= GET | response_status=200
E, [2023-08-11T13:09:19.864135 #1] ERROR -- : service=ui | event=show_all_posts | request_id=a05f44d4-7bb7-4c84-8b35-c69f0209eef8 | message='Failed to read from Post service. Reason: 767: unexpected token at 'Internal Server Error'' | params: "{}"
I, [2023-08-11T13:09:19.880760 #1]  INFO -- : service=ui | event=request | path=/ | request_id=a05f44d4-7bb7-4c84-8b35-c69f0209eef8 | remote_addr=110.139.196.116 | method= GET | response_status=200
E, [2023-08-11T13:09:23.814582 #1] ERROR -- : service=ui | event=show_all_posts | request_id=337062bf-4467-4b2e-b3ec-c1ca914f0873 | message='Failed to read from Post service. Reason: 767: unexpected token at 'Internal Server Error'' | params: "{}"
I, [2023-08-11T13:09:23.830601 #1]  INFO -- : service=ui | event=request | path=/ | request_id=337062bf-4467-4b2e-b3ec-c1ca914f0873 | remote_addr=110.139.196.116 | method= GET | response_status=200


### clean-up
docker kill $(docker ps -q)
docker-machine rm docker-host
yc compute instance delete docker-host
