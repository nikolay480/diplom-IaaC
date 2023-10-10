
# Service account "sa"

data "yandex_iam_service_account" "sa" {
  name        = "sa"
 # description = "Service account for manage instances"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-cr-pusher" {
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"
  member    = "serviceAccount:${data.yandex_iam_service_account.sa.id}"

}

resource "yandex_resourcemanager_folder_iam_member" "sa-cr-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${data.yandex_iam_service_account.sa.id}"
  
}
