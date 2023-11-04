resource "yandex_vpc_address" "ip_addr" {
  name                 = "traefik-ext-ip"
  deletion_protection  = false
  external_ipv4_address {
    zone_id = var.zone
  }
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "traefik-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  name       = "traefik-route-table"
  network_id = yandex_vpc_network.app-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
