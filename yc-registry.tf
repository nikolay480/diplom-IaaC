resource "yandex_iot_core_registry" "dev_registry" {
  name        = "dev-registry"
  description = "test registry for terraform provider documentation"
  labels = {
    test-label = "label-test"
  }
  
#   certificates = [
#     file("<path_to_first_certificate_file>"),
#     file("<path_to_second_certificate_file>")
#   ]
}

output "yandex_iot_core_registry_dev_registry" {
  value = "${yandex_iot_core_registry.dev_registry.id}"
}