**Kubelet**:

The `kubelet` is an agent that runs on each node in a Kubernetes cluster. Its primary role is to ensure that containers are running in a Pod. Here's a brief overview of what the kubelet does:

1. The `kubelet` takes a set of Pod specifications (primarily through the PodSpec) and ensures that the containers described in those specifications are running and healthy.
2. It does not manage containers which were not created by Kubernetes.
3. The `kubelet` also reports to the Kubernetes control plane about the status of the Pods and any events or issues related to them.
4. It communicates with the container runtime using the Container Runtime Interface (CRI) to manipulate containers.

**Kubeadm and Cluster Creation**:

`kubeadm` is a tool built to provide `kubeadm init` and `kubeadm join` as best-practice "fast paths" for creating Kubernetes clusters. Here's a step-by-step breakdown of how `kubeadm` brings up a Kubernetes cluster:

1. **Preflight Checks**: Before initiating the cluster, `kubeadm` performs a set of preflight checks to ensure that the machine is ready to run Kubernetes. These checks include validating the Docker installation, ensuring the machine has enough CPU/memory, checking for port conflicts, etc.

2. **Generate Necessary Configuration and Certificates**: `kubeadm` generates the necessary configuration options for the `kubelet` and the cluster's control plane components (`apiserver`, `controller-manager`, `scheduler`). It also generates certificates necessary for secure communication within the cluster.

3. **Start the control plane**: `kubeadm` initializes the control plane components, starting with the `kubelet`, which, in turn, bootstraps the `apiserver`. Then, the other control plane components (`controller-manager` and `scheduler`) are started.

4. **Set Up `kubeconfig`**: `kubeadm` sets up the `kubeconfig` configuration for the `kubectl` command-line tool, allowing administrators to securely communicate with the `apiserver`.

5. **Set Up Networking**: A Pod network is essential for inter-Pod communication. `kubeadm` doesn't set this up directly but expects the cluster administrator to do this using a Pod Network Add-on (like Calico, Weave, or Flannel).

6. **Additional Cluster Add-ons**: Apart from the Pod network, clusters typically run more add-ons for logging, monitoring, etc. `kubeadm` provides the base layer, and other tools, like Helm, can be used to deploy additional functionalities.

7. **Join Nodes**: With the control plane node(s) in place, additional nodes can be added to the cluster using the `kubeadm join` command. This command requires a token generated during the `kubeadm init` process. The new node's `kubelet` starts up, registers with the `apiserver`, and the node becomes part of the cluster.

8. **Initialization of Cluster State**: Once the control plane is up, `kubeadm` applies a few default configurations, including the default ServiceAccount and Role Bindings.

It's worth noting that while `kubeadm` automates many of the tedious, error-prone aspects of setting up a Kubernetes cluster, it's still a relatively low-level tool, and there are higher-level tools and platforms (like Minikube, KIND, Kops, or managed services from cloud providers) that offer even simpler cluster creation and management experiences.

https://phoenixnap.com/kb/install-kubernetes-on-ubuntu
https://www.linuxsysadmins.com/install-kubernetes-cluster-with-ansible/?amp
### managed k8s by DO:
https://docs.digitalocean.com/products/marketplace/catalog/kubernetes-1-19/

### to fetch yaml tepmlates:
### kubectl create deployment nginx --image=nginx -o yaml --dry-run=client > nginx-deployment.yaml
### kubectl exec -ti pod_name -- sh
### attaches debugging container with tools to the pod, which normally does not have them
### kubectl debug -it pod_name --image=busybox --target=pod_name -- sh
### kubectl edit deployment no-shell
### for docs:
### kubectl explain deployment.spec.template.spec.containers
### to check api directly:
### kubectl proxy --port=8080
### curl http://localhost:8080/api/v1/namespaces/default/pods
