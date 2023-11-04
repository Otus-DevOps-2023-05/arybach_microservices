variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "zone" {
  description = "Zone"
  default = "ru-central1-a"
}

variable "image_id" {
  description = "Disk image"
}

variable "yc_token" {
  description = "YC token"
}

variable "service_account_id" {
  description = "Cluster Admin Service account"
}

variable "service_account_key_file" {
  description = "key .json"
}

variable "k8s_version" {
  description = "Kubernetes version"
  default     = "1.25"
}

variable "ssh_public_key_file" {
  description = "SSH public key"
}

variable "k8s_cidr_block" {
  description = "K8s CIDR block"
  default = "10.1.0.0/16"
}

# variable "domains" {
#   description = "K8s domains to generate certs for"
#   default = ["solarwinds123.ru", "www.solarwinds123.ru"]
# }

# variable "dns_zone" {
#   description = "K8s domain zone"
#   default = "redevops"
# }
