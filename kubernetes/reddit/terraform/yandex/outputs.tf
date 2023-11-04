output "cluster_ca_certificate" {
  description = "PEM-encoded public certificate that is the root of trust for the Kubernetes cluster."
  value       = module.kubernetes.cluster_ca_certificate
}

output "external_v4_endpoint" {
  description = "An IPv4 external network address that is assigned to the master."
  value       = module.kubernetes.external_v4_endpoint
}

output "internal_v4_endpoint" {
  description = "An IPv4 internal network address that is assigned to the master."
  value       = module.kubernetes.internal_v4_endpoint
}

output "cluster_id" {
  description = "ID of the Kubernetes cluster."
  value       = module.kubernetes.cluster_id
}

output "service_account_id" {
  description = "ID of service account used for provisioning Compute Cloud and VPC resources for Kubernetes cluster."
  value       = module.kubernetes.service_account_id
}

output "node_service_account_id" {
  description = "ID of service account to be used by the worker nodes of the Kubernetes cluster to access Container Registry or to push node logs and metrics."
  value       = module.kubernetes.node_service_account_id
}

output "subnet_id" {
  value = yandex_vpc_subnet.app-subnet.id
}

output "traefik_ext_ip" {
  value = yandex_vpc_address.ip_addr.external_ipv4_address.0.address
}

# output "lb_ip_address" {
#   value = yandex_lb_network_load_balancer.k8s_ext_lb.network_interface.0.ip_address
# }

# output "cluster_name" {
#   value = yandex_kubernetes_cluster.k8s-cluster.name
# }

# output "cluster_id" {
#   value = yandex_kubernetes_cluster.k8s-cluster.id
# }

# output "service_account_id" {
#   description = "ID of service account used for provisioning Compute Cloud and VPC resources for Kubernetes cluster."
#   value       = yandex_iam_service_account.k8s-sa.id
# }

# output "subnet_id" {
#   value = yandex_vpc_subnet.app-subnet.id
# }
