resource "yandex_vpc_network" "app-network" {
  name = "slack-app-network"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "slack-app-subnet"
  zone           = var.zone
  network_id     = "${yandex_vpc_network.app-network.id}"
  v4_cidr_blocks = [var.k8s_cidr_block]
}
