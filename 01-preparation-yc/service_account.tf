
# Service account sa

resource "yandex_iam_service_account" "sa" {
  folder_id   = var.folder_id
  description = "Service account SA"
  name        = "sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-storage-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [
    yandex_iam_service_account.sa,
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [
    yandex_iam_service_account.sa,
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "sa-kms-encrypt" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [
    yandex_iam_service_account.sa,
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "sa-cr-pusher" {
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"

}

resource "yandex_resourcemanager_folder_iam_member" "sa-cr-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  
}

resource "yandex_iam_service_account_static_access_key" "sa-storage-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Access keys for my backet"
  depends_on = [
    yandex_iam_service_account.sa,
  ]
}

resource "yandex_iam_service_account_key" "sa-auth-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Authority key"
  key_algorithm      = "RSA_2048"
}

resource "local_file" "service_account_key" {
  content  = jsonencode(yandex_iam_service_account_key.sa-auth-key)
  filename = "sa-key.json"
  depends_on = [
    yandex_iam_service_account.sa,
    yandex_iam_service_account_key.sa-auth-key,
  ]
}
