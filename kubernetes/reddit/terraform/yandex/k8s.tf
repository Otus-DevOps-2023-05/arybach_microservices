module "kubernetes" {
  source = "sport24ru/managed-kubernetes/yandex"
  version = "2.2.1"

  name = "slack-k8s"

  folder_id        = var.folder_id
  network_id       = yandex_vpc_network.app-network.id

  # this should be enabled internally when policy_provider is set: enable_network_policy = true
  network_policy_provider = "CALICO"

  master_locations = [
    {
      subnet_id = yandex_vpc_subnet.app-subnet.id
      zone      = var.zone
    }
  ]

  # These are created by the module
  service_account_name      = "k8s-manager"
  node_service_account_name = "k8s-node-manager"

  # added public ip for master
  master_public_ip = true
  master_version  = var.k8s_version
  release_channel = "RAPID" # You can adjust this if you want a different release channel.
  master_security_group_ids = [yandex_vpc_security_group.k8s-sg.id]

  node_groups = {
    "default" = {
      cores         = 4
      core_fraction = 100
      memory        = 8
      fixed_scale   = {
        size = 3
      }
      security_group_ids = [yandex_vpc_security_group.k8s-sg.id]
      nat               = true
      boot_disk_type = "network-hdd"
      boot_disk_size = 64

    }
  }
  node_groups_default_ssh_keys = {
    admin = [replace(file(var.ssh_public_key_file), "groot@meduza", "admin")],
    user = [replace(file(var.ssh_public_key_file), "groot@meduza", "user")]
  }
}

# resource "yandex_kubernetes_cluster" "k8s-cluster" {
#   description = "Managed Service for Kubernetes cluster"
#   name = "slack-k8s"
#   network_id = yandex_vpc_network.app-network.id

#   master {
#     version = var.k8s_version
#     zonal {
#       zone      = yandex_vpc_subnet.app-subnet.zone
#       subnet_id = yandex_vpc_subnet.app-subnet.id
#     }

#     public_ip = true

#     security_group_ids = [yandex_vpc_security_group.k8s-sg.id]
#   }
#   # service_account_id      = yandex_iam_service_account.k8s-sa.id # Cluster service account ID.
#   service_account_id      = var.service_account_id # Cluster admin service account ID.
#   node_service_account_id = yandex_iam_service_account.k8s-sa.id # Node group service account ID.

#   network_policy_provider = "CALICO"
#   depends_on = [
#     yandex_resourcemanager_folder_iam_member.k8s-admin,
#     yandex_resourcemanager_folder_iam_member.iam-ecr-puller
#   ]
# }

# resource "yandex_kubernetes_node_group" "k8s-node-group" {
#   description = "Node group for the Managed Service for Kubernetes cluster"
#   name        = "k8s-node-group"
#   cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
#   version     = var.k8s_version

#   scale_policy {
#     fixed_scale {
#       size = 3 # Number of hosts
#     }
#   }

#   allocation_policy {
#     location {
#       zone = yandex_vpc_subnet.app-subnet.zone
#     }
#   }

#   instance_template {
#     platform_id = "standard-v2" # Intel Cascade Lake

#     network_interface {
#       nat                = true
#       subnet_ids         = [yandex_vpc_subnet.app-subnet.id]
#       security_group_ids = [yandex_vpc_security_group.k8s-sg.id]
#     }

#     resources {
#       cores         = 4
#       core_fraction = 100
#       memory        = 8
#    }

#     boot_disk {
#       type = "network-hdd"
#       size = 64 # GB
#     }
#   }
# }
