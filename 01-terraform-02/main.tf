# Configuring the provider
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.80.0"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "nik-2023-dev"
    region     = "ru-central1"
    key        = "states/project-diplom.tfstate"
    
    skip_region_validation      = true
    skip_credentials_validation = true

    
  }
}

provider "yandex" {
  folder_id                = var.folder_id
  cloud_id                 = var.cloud_id
  service_account_key_file = file("~/terraform_files/sa-key.json")
}

