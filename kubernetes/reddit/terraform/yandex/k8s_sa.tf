resource "yandex_iam_service_account" "k8s-sa" {
  name = "k8s-backend"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-admin" {
  folder_id = var.folder_id
  role      = "k8s.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-api-admin" {
  folder_id = var.folder_id
  role      = "k8s.cluster-api.cluster-admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-sa-admin" {
  folder_id = var.folder_id
  role      = "iam.serviceAccounts.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-ecr-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-alb-editor" {
  folder_id = var.folder_id
  role      = "alb.editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-vpc-publicAdmin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-vpc-sgAdmin" {
  folder_id = var.folder_id
  role      = "vpc.securityGroups.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-dns-editor" {
  folder_id = var.folder_id
  role      = "dns.editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-storage-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-certs-downloader" {
  folder_id = var.folder_id
  role      = "certificate-manager.certificates.downloader"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-lb-admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "iam-alb-admin" {
  folder_id = var.folder_id
  role      = "alb.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}
# compute.viewer is also needed, but k8s.admin includes it

# Folder-level roles:
# admin
# iam.admin
# iam.serviceAccounts.admin
# k8s.admin
# k8s.cluster-api.cluster-admin
# storage.admin
# load-balancer.admin
