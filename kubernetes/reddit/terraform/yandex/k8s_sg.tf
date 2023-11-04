resource "yandex_vpc_security_group" "k8s-sg" {
  description = "Custom Security Group for Kubernetes"
  name        = "k8s-sg"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.app-network.id

  labels = {
    Terraform = "true"
  }
}

resource "yandex_vpc_security_group_rule" "incoming-traffic" {
  description            = "The rule allows all incoming traffic"
  direction              = "ingress"
  security_group_binding = yandex_vpc_security_group.k8s-sg.id
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  from_port              = 0
  to_port                = 65535
}

resource "yandex_vpc_security_group_rule" "outgoing-traffic" {
  description            = "The rule allows all outgoing traffic"
  direction              = "egress"
  security_group_binding = yandex_vpc_security_group.k8s-sg.id
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  from_port              = 0
  to_port                = 65535
}

# resource "yandex_vpc_security_group_rule" "k8s_ingress_ssh" {
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id

#   direction      = "ingress"
#   v4_cidr_blocks = ["0.0.0.0/0"]
#   protocol       = "TCP"
#   from_port      = 22
#   to_port        = 22
# }

# resource "yandex_vpc_security_group_rule" "k8s_ingress_80" {
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id

#   direction      = "ingress"
#   v4_cidr_blocks = ["0.0.0.0/0"]
#   protocol       = "TCP"
#   from_port      = 80
#   to_port        = 80
# }

# resource "yandex_vpc_security_group_rule" "lb_health_checks_1" {
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id

#   direction      = "ingress"
#   v4_cidr_blocks = ["198.18.235.0/24"]
#   protocol       = "TCP"
#   from_port      = 30589
#   to_port        = 30589
# }

# resource "yandex_vpc_security_group_rule" "lb_health_checks_2" {
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id

#   direction      = "ingress"
#   v4_cidr_blocks = ["198.18.248.0/24"]
#   protocol       = "TCP"
#   from_port      = 30589
#   to_port        = 30589
# }

# # traefik dashboard
# resource "yandex_vpc_security_group_rule" "k8s_ingress_9000" {
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id

#   direction      = "ingress"
#   v4_cidr_blocks = ["0.0.0.0/0"]
#   protocol       = "TCP"
#   from_port      = 9000
#   to_port        = 9000
# }

# # ui and comment
# resource "yandex_vpc_security_group_rule" "k8s_ingress_9292" {
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id

#   direction      = "ingress"
#   v4_cidr_blocks = ["0.0.0.0/0"]
#   protocol       = "TCP"
#   from_port      = 9292
#   to_port        = 9292
# }

# resource "yandex_vpc_security_group_rule" "loadbalancer" {
#   description            = "The rule allows availability checks from the load balancer's range of addresses"
#   direction              = "ingress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "TCP"
#   predefined_target      = "loadbalancer_healthchecks" # The load balancer's address range.
#   from_port              = 0
#   to_port                = 65535
# }

# resource "yandex_vpc_security_group_rule" "node-interaction" {
#   description            = "The rule allows the master-node and node-node interaction within the security group"
#   direction              = "ingress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "ANY"
#   predefined_target      = "self_security_group"
#   from_port              = 0
#   to_port                = 65535
# }

# # this doesn't allow ingress to services interaction when cidr block is set to k8s_cidr_block as ingress gets assigned an ip from nodes block
# resource "yandex_vpc_security_group_rule" "pod-service-interaction" {
#   description            = "The rule allows the pod-pod and service-service interaction"
#   direction              = "ingress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "ANY"
#   v4_cidr_blocks         = [var.k8s_cidr_block]
#   from_port              = 0
#   to_port                = 65535
# }

# resource "yandex_vpc_security_group_rule" "ICMP-debug" {
#   description            = "The rule allows receipt of debugging ICMP packets from internal subnets"
#   direction              = "ingress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "ICMP"
#   v4_cidr_blocks         = [var.k8s_cidr_block]
# }

# resource "yandex_vpc_security_group_rule" "port-6443" {
#   description            = "The rule allows connection to Kubernetes API on 6443 port from the Internet"
#   direction              = "ingress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "TCP"
#   v4_cidr_blocks         = ["0.0.0.0/0"]
#   port                   = 6443
# }

# resource "yandex_vpc_security_group_rule" "port-443" {
#   description            = "The rule allows connection to Kubernetes API on 443 port from the Internet"
#   direction              = "ingress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "TCP"
#   v4_cidr_blocks         = ["0.0.0.0/0"]
#   port                   = 443
# }

# resource "yandex_vpc_security_group_rule" "outgoing-traffic" {
#   description            = "The rule allows all outgoing traffic"
#   direction              = "egress"
#   security_group_binding = yandex_vpc_security_group.k8s-sg.id
#   protocol               = "ANY"
#   v4_cidr_blocks         = ["0.0.0.0/0"]
#   from_port              = 0
#   to_port                = 65535
# }
