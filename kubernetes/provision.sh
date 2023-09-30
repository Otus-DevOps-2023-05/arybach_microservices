#!/bin/bash

# List of your docker machine hosts
HOSTS=("docker-host-1" "docker-host-2")

# Initialize Kubernetes on the first host (master node)
echo "Initializing Kubernetes on ${HOSTS[0]}"
eval $(docker-machine env ${HOSTS[0]})
docker-machine ssh ${HOSTS[0]} "
    sudo apt-get update && sudo apt-get install -y apt-transport-https curl;
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
    echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list;
    sudo apt-get install -y --allow-downgrades docker-ce=5:19.03.14~3-0~ubuntu-focal;
    sudo apt-get update;
    sudo apt-get install -y kubelet='1.19.16-00' kubeadm='1.19.16-00' kubectl='1.19.16-00';
    echo 'KUBELET_EXTRA_ARGS=--container-runtime=docker' | sudo tee /etc/default/kubelet;
    sudo systemctl restart kubelet;
    sudo apt-mark hold kubelet kubeadm kubectl;
    sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml;
    curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml -O;
    sed -i 's/cidr: 192.168.0.0\/16/cidr: 10.244.0.0\/16/' custom-resources.yaml;
    sudo kubeadm init --apiserver-cert-extra-sans=158.160.44.42 --apiserver-advertise-address=0.0.0.0 --control-plane-endpoint=158.160.44.42 --pod-network-cidr=10.244.0.0/16;
    sudo kubectl apply -f custom-resources.yaml;
    mkdir -p \$HOME/.kube;
    sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config;
    sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config;
"
# when using calico - kube-flannel is not needed
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml;
# --pod-network-cidr=10.244.0.0/16 passes proper cidr to calico on kubeadm init
# this substitution is not needed: sed -i 's/cidr: 192.168.0.0\/16/cidr: 10.244.0.0\/16/' custom-resources.yaml;

# Extract the kubeadm join command from the master node
JOIN_COMMAND=$(docker-machine ssh ${HOSTS[0]} "kubeadm token create --print-join-command")

# Join the other host(s) to the Kubernetes cluster (worker node(s))
for i in $(seq 1 $((${#HOSTS[@]} - 1)))
do
    HOST=${HOSTS[$i]}
    echo "Joining $HOST to Kubernetes cluster"
    eval $(docker-machine env $HOST)
    docker-machine ssh $HOST "
        sudo apt-get update && sudo apt-get install -y apt-transport-https curl;
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
        echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list;
        sudo apt-get install -y --allow-downgrades docker-ce=5:19.03.14~3-0~ubuntu-focal;
        sudo apt-get update;
        sudo apt-get install -y kubelet='1.19.16-00' kubeadm='1.19.16-00' kubectl='1.19.16-00';
        echo 'KUBELET_EXTRA_ARGS=--container-runtime=docker' | sudo tee /etc/default/kubelet;
        sudo systemctl restart kubelet;
        sudo apt-mark hold kubelet kubeadm kubectl
    "
    docker-machine ssh $HOST "sudo $JOIN_COMMAND"
done

# Switch back to the master node environment
eval $(docker-machine env ${HOSTS[0]})

# echo "Waiting for k8s to initialize..."
# docker-machine ssh ${HOSTS[0]} "
#     kubectl wait --for=condition=Ready nodes --all --timeout=300s;
# "

# Copy the ./reddit/ directory to the master node
echo "Copying reddit manifests to ${HOSTS[0]}"
docker-machine scp -r ./reddit ${HOSTS[0]}:~/reddit

# Run kubectl commands on the master node
echo "Applying reddit manifests..."
docker-machine ssh ${HOSTS[0]} "
    kubectl apply -f ~/reddit/
"

# Run kubectl commands on the master node to verify
echo "Checking.."
docker-machine ssh ${HOSTS[0]} "
    kubectl get all;
    kubectl get pods;
    kubectl describe pods;
"
# all details and logs are available in k9s
