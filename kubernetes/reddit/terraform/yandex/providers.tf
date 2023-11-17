terraform {
  required_version = ">= 0.13.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.93.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  # endpoint                 = "api.cloud.yandex.net:443" # this is default
}
