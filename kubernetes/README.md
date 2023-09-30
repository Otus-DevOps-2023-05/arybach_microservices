# Create the first node
```
yc compute instance create \
--name docker-host-1 \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=45 \
--ssh-key ~/.ssh/yc.pub \
--cores 4 \
--memory 4
```
```
ssh -i ~/.ssh/yc yc-user@158.160.44.42
### then repeat for the worker
ssh -i ~/.ssh/yc yc-user@158.160.118.222
### execute the following commands to downgrade docker version
sudo apt-get update -y

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y

sudo apt-get install -y docker-ce=5:19.03.15~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.15~3-0~ubuntu-$(lsb_release -cs) containerd.io
exit
```

# Create the second node
```
yc compute instance create \
--name docker-host-2 \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=45 \
--ssh-key ~/.ssh/yc.pub \
--cores 4 \
--memory 4
```

# now switching between nodes with docker-machine
```
docker-machine create \
--driver generic \
--generic-ip-address=158.160.44.42 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/yc \
docker-host-1
```

```
docker-machine create \
--driver generic \
--generic-ip-address=158.160.118.222 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/yc \
docker-host-2
```

# checking:
```
[0] % docker-machine ls
NAME            ACTIVE   DRIVER    STATE     URL                          SWARM   DOCKER      ERRORS
docker-host-1   -        generic   Running   tcp://158.160.44.42:2376             v19.03.15
docker-host-2   -        generic   Running   tcp://158.160.118.222:2376           v19.03.15
```

### settign up one after another
```
eval $(docker-machine env docker-host-1)
```
### or
```
eval $(docker-machine env docker-host-2)
```
### to reset back to local docker
```
eval $(docker-machine env -u)
```

## or copy IPs of both hosts to the provision.sh file and run it
```
chmod +x provision.sh
./provision.sh
```
```
yc-user@docker-host-1:~$ kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
docker-host-1   Ready    master   40m   v1.19.16
docker-host-2   Ready    <none>   39m   v1.19.16
```
```
### and after manifests are copied over:
yc-user@docker-host-1:~$ kubectl get all
NAME                                      READY   STATUS    RESTARTS   AGE
pod/comment-deployment-5bfdf9cc79-d5sdf   0/1     Pending   0          89s
pod/mongodb-deployment-6bc8bf8bbf-jnw54   0/1     Pending   0          89s
pod/post-deployment-6c6477665f-kkzv4      0/1     Pending   0          89s
pod/ui-deployment-548dbd749f-ts8tg        0/1     Pending   0          89s

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
service/kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP     2m41s
service/mongodb-service   ClusterIP   10.98.107.177   <none>        27017/TCP   89s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/comment-deployment   0/1     1            0           89s
deployment.apps/mongodb-deployment   0/1     1            0           89s
deployment.apps/post-deployment      0/1     1            0           89s
deployment.apps/ui-deployment        0/1     1            0           89s

NAME                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/comment-deployment-5bfdf9cc79   1         1         0       89s
replicaset.apps/mongodb-deployment-6bc8bf8bbf   1         1         0       89s
replicaset.apps/post-deployment-6c6477665f      1         1         0       89s
replicaset.apps/ui-deployment-548dbd749f        1         1         0       89s
```

## use k9s for monitoring
rm ,/kubeconfig
ssh -i ~/.ssh/yc yc-user@158.160.44.42
sudo cp /etc/kubernetes/admin.conf /tmp/admin.conf
sudo chmod 644 /tmp/admin.conf
exit
scp -i ~/.ssh/yc yc-user@158.160.44.42:/tmp/admin.conf ./kubeconfig
k9s --kubeconfig=./kubeconfig
k9s --kubeconfig=/media/groot/data/arybach_microservices/kubernetes/kubeconfig

![Alt text](image.png)

### and after manifests are copied over
![Alt text](image-1.png)

### clean up
```
docker-machine rm docker-host-1
docker-machine rm docker-host-2
yc compute instance delete docker-host-1 docker-host-2
```
