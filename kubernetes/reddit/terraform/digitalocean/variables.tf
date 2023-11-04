variable "do_token" {
  default = "..."
}

variable "region" {
  default = "sgp1"
}

variable "k8s_clustername" {
  default = "slack-k8s"
}

variable "k8s_version" {
  default = "1.27"
}

variable "k8s_poolname" {
  default = "worker-pool"
}

variable "k8s_count" {
  default = "3"
}
