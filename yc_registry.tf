resource "yandex_container_registry" "dev-cr" {
  name = "dev-cr"
  folder_id = var.folder_id
  labels = {
    my-label = "dev"
  }
}