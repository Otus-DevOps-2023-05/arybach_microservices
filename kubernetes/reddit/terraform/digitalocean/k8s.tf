terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0" # specify the version you want to use
    }
  }
}

provider "digitalocean"{
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name    = var.k8s_clustername
  region  = var.region
  version = var.k8s_version

  tags = ["k8s"]

  # This default node pool is mandatory
  node_pool {
    name       = var.k8s_poolname
    size       = "s-4vcpu-8gb"
    auto_scale = false
    node_count = var.k8s_count
    tags       = ["node-pool-tag"]
  }

}

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.kubernetes_cluster.id
}
